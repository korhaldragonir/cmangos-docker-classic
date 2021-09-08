#!/bin/sh
# Fetch Packages needed
echo "Starting Initialization of CMaNGOS DB..."

# Prepare Databases
mysql -uroot -pmangos -e "create database classiccharacters;"
mysql -uroot -pmangos -e "create database classiclogs;"
mysql -uroot -pmangos -e "create database classicmangos;"
mysql -uroot -pmangos -e "create database classicrealmd;"
mysql -uroot -pmangos -e "create user 'mangos'@'%' identified by 'mangos';"
mysql -uroot -pmangos -e "grant all privileges on classiccharacters.* to 'mangos'@'%';"
mysql -uroot -pmangos -e "grant all privileges on classiclogs.* to 'mangos'@'%';"
mysql -uroot -pmangos -e "grant all privileges on classicmangos.* to 'mangos'@'%';"
mysql -uroot -pmangos -e "grant all privileges on classicrealmd.* to 'mangos'@'%';"

# Clone core code
echo "Core Version: ${ENV_CORE_COMMIT_HASH}"
git clone https://github.com/cmangos/mangos-classic.git /tmp/cmangos
if [ "$ENV_CORE_COMMIT_HASH" != "HEAD" ]; then
  echo -e "Switching to Core Commit: ${ENV_CORE_COMMIT_HASH}\n"
  cd /tmp/cmangos
  git checkout ${ENV_CORE_COMMIT_HASH}
fi

# Clone db code
echo "DB Version: ${ENV_DB_COMMIT_HASH}"
git clone https://github.com/cmangos/classic-db.git /tmp/db
if [ "$ENV_DB_COMMIT_HASH" != "HEAD" ]; then
  echo -e "Switching to DB Commit: ${ENV_DB_COMMIT_HASH}\n"
  cd /tmp/db
  git checkout ${ENV_DB_COMMIT_HASH}
fi

# Create default database structures
if [ -f /tmp/cmangos/sql/base/characters.sql ]; then
  mysql -uroot -pmangos classiccharacters < /tmp/cmangos/sql/base/characters.sql
fi

if [ -f /tmp/cmangos/sql/base/logs.sql ]; then
  mysql -uroot -pmangos classiclogs < /tmp/cmangos/sql/base/logs.sql
fi

if [ -f /tmp/cmangos/sql/base/mangos.sql ]; then
  mysql -uroot -pmangos classicmangos < /tmp/cmangos/sql/base/mangos.sql
fi

if [ -f /tmp/cmangos/sql/base/realmd.sql ]; then
  mysql -uroot -pmangos classicrealmd < /tmp/cmangos/sql/base/realmd.sql
fi

# Copy install script
cp -v /docker-entrypoint-initdb.d/InstallFullDB.config /tmp/db/InstallFullDB.config

# Run install scripy
cd /tmp/db
./InstallFullDB.sh

# Cleanup
cd /
rm -rf /tmp/db
rm -rf /tmp/cmangos
