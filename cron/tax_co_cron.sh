cd /mnt/tax_co
export PYTHONPATH=/mnt/tax_co:$PYTHONPATH
/opt/conda/bin/python3      \
    python/requests/main.py \
    config/config.json      \
    try-to-advance-queue
