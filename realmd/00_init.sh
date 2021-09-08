#!/bin/bash

# Check ENV settings and print them.
echo "==========[ CMaNGOS realmd Init ]==========";
echo "[INFO] REALMD_DB: ${REALMD_DB}";
echo "";
echo "[INFO] DB_USER: ${DB_USER}";
echo "[INFO] DB_PASS: ${DB_PASS}";
echo "";
echo "[INFO] DB_SERVER: ${DB_SERVER}";
echo "";

/wait-for-it.sh ${DB_SERVER}:3306 -t 900

if [ $? -eq 0 ]; then
    # Check if intialized
    if [ -f "/opt/cmangos/etc/.intialized" ]; then
        echo "[RUN] Realm already intialized. Starting realmdd...";

        # Run CMaNGOS
        cd /opt/cmangos/bin/
        ./realmd
        exit 0;
    else
        # Init Code
        echo "[INIT] Realm not intialized. Initializing...";
        echo "";
        echo "[INIT] Realm Configuring database settings...";
        # Configure DB Settings
        sed -i 's/LoginDatabaseInfo.*/LoginDatabaseInfo     = "'${DB_SERVER}';3306;'${DB_USER}';'${DB_PASS}';'${REALMD_DB}'"/g' /opt/cmangos/etc/realmd.conf
        echo "[INIT] Realm database settings set.";

        # Create .initialized file
        touch /opt/cmangos/etc/.intialized

        # Run CMaNGOS
        echo "[RUN] Starting realmd...";
        cd /opt/cmangos/bin/
        ./realmd
        exit 0;
    fi
else
    echo "[ERR] Timeout while waiting for ${DB_SERVER}!";
    exit 1;
fi
