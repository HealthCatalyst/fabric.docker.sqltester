
# curl -useb https://raw.githubusercontent.com/HealthCatalyst/fabric.docker.sqltester/master/run.ps1 | iex;

docker stop fabric.docker.sqltester
docker rm fabric.docker.sqltester
docker pull healthcatalyst/fabric.docker.sqltester

$USERNAME=$($env:USERNAME)
$AD_DOMAIN=$env:USERDNSDOMAIN
$AD_DOMAIN_SERVER=$($env:LOGONSERVER).Replace("\\","")
$TEST_SQL_SERVER="$env:computername.$env:userdnsdomain"
# $TEST_SQL_SERVER="imranedw2.hqcatalyst.local"

$password = Read-Host -assecurestring "Please enter your password for ${USERNAME}@${AD_DOMAIN}"
$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Write-Host "user: $USERNAME"
Write-Host "domain: $AD_DOMAIN"
Write-Host "domain server: $AD_DOMAIN_SERVER"

docker run --rm -e SERVICE_USER=$USERNAME -e SERVICE_PASSWORD=$password -e AD_DOMAIN=$AD_DOMAIN -e AD_DOMAIN_SERVER=$AD_DOMAIN_SERVER -e TEST_SQL_SERVER=$TEST_SQL_SERVER --name fabric.docker.sqltester -t healthcatalyst/fabric.docker.sqltester
