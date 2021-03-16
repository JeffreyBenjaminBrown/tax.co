# SHARED MEMORY STRATEGY
# ######################
# The webpage (tax.co.web) adds requests to `requests.temp.csv`.
# Anything accessing that file uses a file lock for it.
# Such access is always brief; no process will make another wait long.
# #
# The microsimulation (tax.co) transfers files from `requests.temp.csv`
# to `requests.csv`. Then it processes those requests.
# It is the only process that manipulates `requests.csv`,
# so it doesn't need to worry about getting clobbered.

# PITFALL
# ######
# This Python program is meant to be called, either from another one --
# the Django server defined by the repo at
#   github.com:ofiscal/tax.co.web
# -- or by a cron job.

# How to invoke this code:
# ########################
# the first non-mandatory argument to `python3` at the command line
# should be a path to a user configuration,
# and the second should be an action to take.
# For example,
#   PYTHONPATH=/mnt/tax_co python3 python/requests/main.py users/jeff/config/shell.json add-to-queue

if True:
  import filelock
  import json
  import os
  import pandas as pd
  import subprocess
  import sys
  from   typing import Callable, Dict
  #
  import python.requests.lib  as lib


tax_co_root_folder = "/mnt/tax_co"
process_marker     = os.path.join ( tax_co_root_folder,
                                    "data/incomplete-request" )
users_folder       = os.path.join ( tax_co_root_folder,
                                    "users/" )
constraints_file   = os.path.join ( tax_co_root_folder,
                                    "data/constraints-time-memory.json" )
requests_file      = os.path.join ( tax_co_root_folder,
                                    "data/requests.csv" )
requests_temp_file = os.path.join ( tax_co_root_folder,
                                    "data/requests.temp.csv" )
with open ( constraints_file ) as f:
    constraints = json . load ( f )

lock = filelock . FileLock ( requests_temp_file + ".lock" )
    # Since requests_file is only ever manipulated by tax.co,
    # it does not need a lock. requests_temp_file, however,
    # is manipulated by tax.co.web also.
    # (Both only ever manipulate it through this program,
    # but more than one instance could be running at once.)

def transfer_requests_from_temp_queue ():
    with lock:
        reqs = lib . read_requests ( requests_file )
        reqs_temp = lib . read_requests ( requests_temp_file )
        reqs = lib . canonicalize_requests (
            pd . concat ( [reqs, reqs_temp] ) )
        lib . write_requests ( reqs,                    requests_file )
        lib . write_requests ( lib . empty_requests (), requests_temp_file )

def advance_request_queue ( user_hash : str ):
    tax_co_root = "/mnt/tax_co/" # absolute b/c this is callable from cron
    user_root = os . path . join ( tax_co_root, "users", user_hash )
    my_env = os . environ . copy ()
    with open ( process_marker, "w" ) as f:
        f . write ( user_hash )
    my_env["PYTHONPATH"] = (
        tax_co_root + ":" + my_env [ "PYTHONPATH" ]
        if "PYTHONPATH" in my_env . keys ()
        else tax_co_root )
    sp = subprocess . run (
        [ "python3",
          "bash/run-makefile.py",
          os . path . join ( user_root, "config/shell.json" ) ],
        env    = my_env,
        stdout = subprocess . PIPE,
        stderr = subprocess . PIPE )
    for ( path, source ) in [ ("stdout.txt", sp.stdout),
                              ("stderr.txt", sp.stderr) ]:
      with open ( os.path.join ( user_root, path ),
                  "a" ) as f:
        f . write ( datetime . now () + "\n" )
        f . write ( source )
    if sp . returncode == 0:
        lib . mutate ( requests_file,
                       lambda reqs: lib . mark_complete ( reqs ) )
        os . remove ( process_marker )

def try_to_advance_request_queue ():
    # TODO: Test.
    reqs = lib . read_requests ( requests_file )
    if ( os.path.exists ( process_marker )
         | ( not unexecuted_requests_exist ( reqs ) ) ):
        return ()
    if lib . memory_permits_another_run (
            lib.gb_used ( users_folder ),
            constraints ):
        advance_request_queue ()
    elif lib . at_least_one_is_old ( reqs, constraints ):
        delete_oldest_user_folder ( requests_file, users_folder )
        try_to_advance_request_queue ()
          # Recurse. Hopefully, now memory permits --
          # but since a user can choose a small sample size,
          # it might still not.

if len ( sys.argv ) > 1:
    action = sys . argv [ 2 ]
      # 0 is the path to this program path, 1 the .json config
    lib . initialize_requests ( requests_file )
    with lock:
        lib . initialize_requests ( requests_temp_file )

    # What the cron job does.
    if action == "try-to-advance":
        transfer_requests_from_temp_queue ()
        try_to_advance_request_queue ()

    # What the web page (the tax.co.web repo) does.
    if action == "add-to-queue":
        with lock:
          lib . mutate (
              requests_temp_file,
              lambda reqs: lib . append_request (
                  reqs, lib . this_request () ) )