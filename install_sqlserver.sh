#!/bin/bash
set -e

echo "🔹 Step 1: Importing Microsoft GPG key..."
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

echo "🔹 Step 2: Adding SQL Server 2022 repository..."
UBUNTU_VERSION=$(lsb_release -rs)
sudo add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/$UBUNTU_VERSION/mssql-server-2022.list)"

echo "🔹 Step 3: Updating package index..."
sudo apt-get update

echo "🔹 Step 4: Installing Microsoft SQL Server..."
sudo ACCEPT_EULA=Y apt-get install -y mssql-server

echo "🔹 Step 5: Running initial SQL Server setup..."
sudo /opt/mssql/bin/mssql-conf setup

echo "🔹 Step 6: Enabling SQL Server service..."
sudo systemctl enable mssql-server
sudo systemctl start mssql-server
sudo systemctl status mssql-server --no-pager

echo "🔹 Step 7: Adding SQL command-line tools..."
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo add-apt-repository "$(curl https://packages.microsoft.com/config/ubuntu/$UBUNTU_VERSION/prod.list)"
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install -y mssql-tools18 unixodbc-dev

echo "🔹 Step 8: Adding mssql-tools to PATH..."
if ! grep -q '/opt/mssql-tools18/bin' ~/.bashrc; then
  echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
fi
source ~/.bashrc

echo "✅ Installation completed successfully!"
echo "👉 Use the following command to connect:"
echo "/opt/mssql-tools18/bin/sqlcmd -S localhost,1433 -U sa -P 'YourStrongPassword123' -C"
