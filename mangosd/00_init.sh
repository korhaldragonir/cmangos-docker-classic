#!/bin/bash

# Check ENV settings and print them.
echo "==========[ CMaNGOS mangosd Init ]==========";
echo "[INFO] CHARACTERS_DB: ${CHARACTERS_DB}";
echo "[INFO] LOGS_DB: ${LOGS_DB}";
echo "[INFO] MANGOSD_DB: ${MANGOSD_DB}";
echo "[INFO] REALMD_DB: ${REALMD_DB}";
echo "";
echo "[INFO] DB_USER: ${DB_USER}";
echo "[INFO] DB_PASS: ${DB_PASS}";
echo "[INFO] REALMD_USER: ${REALMD_USER}";
echo "[INFO] REALMD_PASS: ${REALMD_PASS}";
echo "";
echo "[INFO] DB_SERVER: ${DB_SERVER}";
echo "[INFO] REALMD_SERVER: ${REALMD_SERVER}";
echo "";

/wait-for-it.sh ${DB_SERVER}:3306 -t 900
if [ $? -ne 0 ]; then
	echo "[ERR] Timeout while waiting for ${DB_SERVER}!";
	exit 1;
fi

if [ ${DB_SERVER} -ne ${REALMD_SERVER} ]; then
	/wait-for-it.sh ${REALMD_SERVER}:3306 -t 900
fi

if [ $? -eq 0 ]; then
	# Check if intialized
	if [ -f "/opt/cmangos/etc/.intialized" ]; then
	    echo "[RUN] CMaNGOS already intialized. Starting mangosd...";

	    # Run CMaNGOS
	    cd /opt/cmangos/bin
	    ./mangosd
	    exit 0;
	else
	    # Init Code
	    echo "[INIT] CMaNGOS not intialized. Initializing...";
	    echo "";
	    echo "[INIT] CMaNGOS Configuring database settings...";
	    # Configure DB Settings
	    sed -i 's/LoginDatabaseInfo.*/LoginDatabaseInfo     = "'${REALMD_SERVER}';3306;'${REALMD_USER}';'${REALMD_PASS}';'${REALMD_DB}'"/g' /opt/cmangos/etc/mangosd.conf
	    sed -i 's/WorldDatabaseInfo.*/WorldDatabaseInfo     = "'${DB_SERVER}';3306;'${DB_USER}';'${DB_PASS}';'${MANGOSD_DB}'"/g' /opt/cmangos/etc/mangosd.conf
	    sed -i 's/CharacterDatabaseInfo.*/CharacterDatabaseInfo \= "'${DB_SERVER}';3306;'${DB_USER}';'${DB_PASS}';'${CHARACTERS_DB}'"/g' /opt/cmangos/etc/mangosd.conf
			sed -i 's/LogsDatabaseInfo.*/LogsDatabaseInfo \= "'${DB_SERVER}';3306;'${DB_USER}';'${DB_PASS}';'${LOGS_DB}'"/g' /opt/cmangos/etc/mangosd.conf
	    echo "[INIT] CMaNGOS database settings set.";

	    # Create .initialized file
	    touch /opt/cmangos/etc/.intialized

	    # Run CMaNGOS
	    echo "[RUN] Starting mangosd...";
	    cd /opt/cmangos/bin
	    ./mangosd
	    exit 0;
	fi
else
	echo "[ERR] Timeout while waiting for ${REALMD_SERVER}!";
	exit 1;
fi