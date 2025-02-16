param(
    [string]$WebsiteName = "DemoWebApp",
    [string]$PhysicalPath = "C:\inetpub\wwwroot\DemoWebApp",
    [string]$AppPoolName = "DemoWebAppPool"
)

# 停止網站
if (Get-Website -Name $WebsiteName) {
    Stop-Website -Name $WebsiteName
}

# 停止應用程式集區
if (Get-WebAppPool -Name $AppPoolName) {
    Stop-WebAppPool -Name $AppPoolName
}

# 建置專案
dotnet build --configuration Release

# 發布專案
dotnet publish --configuration Release --output $PhysicalPath

# 啟動應用程式集區
Start-WebAppPool -Name $AppPoolName

# 啟動網站
Start-Website -Name $WebsiteName

Write-Host "部署完成！"