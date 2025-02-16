param(
    [string]$WebsiteName = "DemoWebApp",
    [string]$PhysicalPath = "C:\inetpub\wwwroot\DemoWebApp",
    [string]$AppPoolName = "DemoWebAppPool",
    [string]$ProjectPath = "C:\Users\user\source\repos\TestCICD\src\TestCICD.Web\TestCICD.Web\TestCICD.Web.csproj"
)

try {
    Write-Host "開始部署流程..." -ForegroundColor Yellow

    # 檢查專案檔是否存在
    if (!(Test-Path $ProjectPath)) {
        Write-Host "找不到專案檔: $ProjectPath" -ForegroundColor Red
        exit 1
    }

    # 檢查 IIS 網站是否存在
    if (!(Get-Website -Name $WebsiteName)) {
        Write-Host "網站不存在，請先在 IIS 建立網站" -ForegroundColor Red
        exit 1
    }

    # 停止網站
    Write-Host "停止網站..." -ForegroundColor Yellow
    Stop-Website -Name $WebsiteName
    Stop-WebAppPool -Name $AppPoolName

    # 建置專案
    Write-Host "建置專案..." -ForegroundColor Yellow
    dotnet build $ProjectPath --configuration Release
    if ($LASTEXITCODE -ne 0) {
        throw "建置失敗"
    }

    # 發布專案
    Write-Host "發布專案..." -ForegroundColor Yellow
    dotnet publish $ProjectPath --configuration Release --output $PhysicalPath
    if ($LASTEXITCODE -ne 0) {
        throw "發布失敗"
    }

    # 啟動應用程式集區和網站
    Write-Host "啟動網站..." -ForegroundColor Yellow
    Start-WebAppPool -Name $AppPoolName
    Start-Website -Name $WebsiteName

    Write-Host "部署完成！" -ForegroundColor Green
    Write-Host "請訪問: http://localhost:8080" -ForegroundColor Green
}
catch {
    Write-Host "部署過程發生錯誤: $_" -ForegroundColor Red
    exit 1
}