#!/bin/bash
#
#   Copyright 2020 Nofanto Ibrahim
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
POSTGRES_BINARIES_URL="https://sbp.enterprisedb.com/getfile.jsp?fileid=12475"
POSTGRES_VERSION="12.2"

postgres_zip_file="postgres-${POSTGRES_VERSION}.zip"
postgres_dir="pgsql"
data_dir="data"
dir=$(PWD)

echo "Looking for previous installation"
if [ -d "$postgres_dir" ]; then
	echo "PostgreSQL found."
	echo ""
	echo "======================================================================================================"
	echo "Issue the following command in terminal to start PostgreSQL server:"
    echo ""
    echo "    pstart"
    echo ""
    echo "Issue the following command in terminal to stop PostgreSQL server:"
    echo ""
    echo "    pstop"
    echo ""
    echo "Once the PostgreSQL started, you can connect to localhost with user postgres (No Password):"
    echo ""
    echo "    psql -h localhost -U postgres"
    echo ""
	echo "======================================================================================================"
	echo ""
	exit 0
fi

echo "Looking for unzip..."
if [ -z $(which unzip) ]; then
	echo "Not found."
	echo "======================================================================================================"
	echo " Please install unzip on your system using your favourite package manager."
	echo ""
	echo " Restart after installing unzip."
	echo "======================================================================================================"
	echo ""
	exit 1
fi

echo "Looking for curl..."
if [ -z $(which curl) ]; then
	echo "Not found."
	echo ""
	echo "======================================================================================================"
	echo " Please install curl on your system using your favourite package manager."
	echo ""
	echo " Restart after installing curl."
	echo "======================================================================================================"
	echo ""
	exit 1
fi

echo "This will install PostgreSQL in this folder"

echo "Download PostgreSQL Binaries..."
curl --location --progress-bar "${POSTGRES_BINARIES_URL}" > "$postgres_zip_file"

ARCHIVE_OK=$(unzip -qt "$postgres_zip_file" | grep 'No errors detected in compressed data')
if [[ -z "$ARCHIVE_OK" ]]; then
	echo "Downloaded zip archive corrupt. Are you connected to the internet?"
	echo ""
	rm "$postgres_zip_file"
	exit 2
fi

echo "Extracting PostgreSQL Binaries..."
unzip -q $postgres_zip_file

echo "Setup permission for PostgreSQL"
cd ${postgres_dir}
xattr -d com.apple.quarantine ./bin/initdb
xattr -d com.apple.quarantine ./lib/libcrypto.1.1.dylib
xattr -d com.apple.quarantine ./lib/postgresql/dict_snowball.so
xattr -d com.apple.quarantine ./lib/postgresql/plpgsql.so
xattr -d com.apple.quarantine ./lib/postgresql/llvmjit.so
xattr -d com.apple.quarantine ./bin/pg_ctl
xattr -d com.apple.quarantine ./bin/psql

echo "Preparing default database"
mkdir ${data_dir}
./bin/initdb -D ./data/ -U postgres -A trust

echo "Add runner scripts to bash profile"
echo "alias psql='${dir}/${postgres_dir}/bin/psql'" >> ~/.bash_profile
echo "alias pstart='${dir}/${postgres_dir}/bin/pg_ctl -D ${dir}/${postgres_dir}/data/ -l ${dir}/${postgres_dir}/data/logfile start'" >> ~/.bash_profile
echo "alias pstop='${dir}/${postgres_dir}/bin/pg_ctl -D ${dir}/${postgres_dir}/data/ -l ${dir}/${postgres_dir}/data/logfile stop'" >> ~/.bash_profile
source ~/.bash_profile

echo "Cleanup..."
cd $dir
rm $postgres_zip_file

echo "Done."
echo ""
echo "Please open a new terminal, and then"
echo ""
echo "Issue the following command in terminal to start PostgreSQL server:"
echo ""
echo "    pstart"
echo ""
echo "Issue the following command in terminal to stop PostgreSQL server:"
echo ""
echo "    pstop"
echo ""
echo "Once the PostgreSQL started, you can connect to localhost with user postgres (No Password):"
echo ""
echo "    psql -h localhost -U postgres"
echo ""
echo "Enjoy!!!"


