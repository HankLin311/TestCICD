param(
    [string]$WebsiteName = "DemoWebApp",
    [string]$PhysicalPath = "C:\inetpub\wwwroot\DemoWebApp",
    [string]$AppPoolName = "DemoWebAppPool",
    [string]$ProjectPath = "C:\Users\user\source\repos\TestCICD\src\TestCICD.Web\TestCICD.Web\TestCICD.Web.csproj"
)

try {
    Write-Host "�}�l���p�y�{..." -ForegroundColor Yellow

    # �ˬd�M���ɬO�_�s�b
    if (!(Test-Path $ProjectPath)) {
        Write-Host "�䤣��M����: $ProjectPath" -ForegroundColor Red
        exit 1
    }

    # �ˬd IIS �����O�_�s�b
    if (!(Get-Website -Name $WebsiteName)) {
        Write-Host "�������s�b�A�Х��b IIS �إߺ���" -ForegroundColor Red
        exit 1
    }

    # �������
    Write-Host "�������..." -ForegroundColor Yellow
    Stop-Website -Name $WebsiteName
    Stop-WebAppPool -Name $AppPoolName

    # �ظm�M��
    Write-Host "�ظm�M��..." -ForegroundColor Yellow
    dotnet build $ProjectPath --configuration Release
    if ($LASTEXITCODE -ne 0) {
        throw "�ظm����"
    }

    # �o���M��
    Write-Host "�o���M��..." -ForegroundColor Yellow
    dotnet publish $ProjectPath --configuration Release --output $PhysicalPath
    if ($LASTEXITCODE -ne 0) {
        throw "�o������"
    }

    # �Ұ����ε{�����ϩM����
    Write-Host "�Ұʺ���..." -ForegroundColor Yellow
    Start-WebAppPool -Name $AppPoolName
    Start-Website -Name $WebsiteName

    Write-Host "���p�����I" -ForegroundColor Green
    Write-Host "�гX��: http://localhost:8080" -ForegroundColor Green
}
catch {
    Write-Host "���p�L�{�o�Ϳ��~: $_" -ForegroundColor Red
    exit 1
}