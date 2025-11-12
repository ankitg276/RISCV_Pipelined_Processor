# Compile and run the pipeline testbench and open GTKWave if available
# Run this from PowerShell in the project folder

$tb = "pipeline_tb.v"
$top = "Pipeline_top.v"
$out = "pipeline_tb.vvp"

Write-Host "Compiling $tb and $top..."
$compile = iverilog -o $out $tb $top 2>&1
Write-Host $compile

if ($LASTEXITCODE -ne 0) {
    Write-Host "iverilog failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Running simulation (vvp) ..."
$vvp = vvp $out 2>&1
Write-Host $vvp

if (Test-Path "dump.vcd") {
    Write-Host "dump.vcd created. Attempting to open with gtkwave..."
    if (Get-Command gtkwave -ErrorAction SilentlyContinue) {
        Start-Process gtkwave -ArgumentList 'dump.vcd','pipeline.gtkw'
    } else {
        Write-Host "gtkwave not found. Open dump.vcd with GTKWave manually or install GTKWave."
    }
} else {
    Write-Host "No dump.vcd found. Check simulation output for errors/warnings."
}
