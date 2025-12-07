# 產生 IPIP 題庫對照表的腳本

Write-Host "=== IPIP 題庫對照表生成工具 ===" -ForegroundColor Cyan
Write-Host ""

# 載入資料
Write-Host "正在載入資料..." -ForegroundColor Yellow
$ipip3320 = Get-Content "docs/ex03/IPIP3320.csv" | ConvertFrom-Csv -Header "Survey","ItemNumber" | Select-Object -Skip 1
$items_en = Get-Content "ex05/IPIP_items.csv" | ConvertFrom-Csv
$items_zh = Get-Content "ex05/IPIP_items-zh-tw.csv" | ConvertFrom-Csv

Write-Host "  IPIP3320: $($ipip3320.Count) 題" -ForegroundColor Green
Write-Host "  IPIP_items (EN): $($items_en.Count) 題" -ForegroundColor Green  
Write-Host "  IPIP_items (ZH): $($items_zh.Count) 題" -ForegroundColor Green
Write-Host ""

# 建立對照表
Write-Host "正在建立對照表..." -ForegroundColor Yellow
$mapping = @()
$matchedCount = 0
$unmatchedCount = 0

for ($i = 0; $i -lt $items_en.Count; $i++) {
    $en = $items_en[$i]
    $zh = $items_zh[$i]
    
    # 在 IPIP3320 中尋找匹配的 ItemNumber
    $match = $ipip3320 | Where-Object { $_.Survey -eq $en.text } | Select-Object -First 1
    
    if ($match) {
        $itemNumber = $match.ItemNumber
        $matchedCount++
    } else {
        # 自動生成 ItemNumber
        $itemNumber = "$($en.instrument)_$('{0:D4}' -f ($i + 1))"
        $unmatchedCount++
    }
    
    $mapping += [PSCustomObject]@{
        RowId = $i + 1
        ItemNumber = $itemNumber
        Instrument = $en.instrument
        Label = $en.label
        Alpha = $en.alpha
        Key = $en.key
        TextEn = $en.text
        TextZh = $zh.text
        HasOriginalItemNumber = if ($match) { 'Yes' } else { 'No' }
    }
    
    if (($i + 1) % 500 -eq 0) {
        Write-Host "  已處理 $($i + 1) 題..." -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "對照完成!" -ForegroundColor Green
Write-Host "  匹配到原始 ItemNumber: $matchedCount 題" -ForegroundColor Cyan
Write-Host "  自動生成編號: $unmatchedCount 題" -ForegroundColor Yellow
Write-Host ""

# 匯出完整對照表
$outputFile = "docs/ex06/ipip-item-mapping.csv"
Write-Host "正在匯出對照表到 $outputFile ..." -ForegroundColor Yellow
$mapping | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8
Write-Host "  完成!" -ForegroundColor Green
Write-Host ""

# 匯出僅包含原始 ItemNumber 的清單
$originalItemsFile = "docs/ex06/ipip-original-items.csv"
Write-Host "正在匯出原始 ItemNumber 清單到 $originalItemsFile ..." -ForegroundColor Yellow
$mapping | Where-Object { $_.HasOriginalItemNumber -eq 'Yes' } | 
    Export-Csv -Path $originalItemsFile -NoTypeInformation -Encoding UTF8
Write-Host "  完成!" -ForegroundColor Green
Write-Host ""

# 統計報告
Write-Host "=== 統計報告 ===" -ForegroundColor Cyan
Write-Host ""

# 按 Instrument 統計
Write-Host "按量表分類:" -ForegroundColor Yellow
$grouped = $mapping | Group-Object Instrument | Sort-Object Count -Descending
foreach ($group in $grouped) {
    $withOriginal = ($group.Group | Where-Object { $_.HasOriginalItemNumber -eq 'Yes' }).Count
    Write-Host ("  {0,-20} {1,4} 題 (原始編號: {2,4} 題)" -f $group.Name, $group.Count, $withOriginal)
}
Write-Host ""

# ItemNumber 前綴統計
Write-Host "ItemNumber 前綴分布:" -ForegroundColor Yellow
$originalItems = $mapping | Where-Object { $_.HasOriginalItemNumber -eq 'Yes' }
$prefixGroups = $originalItems | ForEach-Object { $_.ItemNumber -replace '\d+', '' } | Group-Object | Sort-Object Count -Descending
foreach ($prefix in $prefixGroups) {
    Write-Host ("  {0,-10} {1,4} 題" -f $prefix.Name, $prefix.Count)
}
Write-Host ""

Write-Host "所有檔案已生成完成!" -ForegroundColor Green
Write-Host ""
Write-Host "輸出檔案:" -ForegroundColor Cyan
Write-Host "  1. $outputFile (完整對照表)" -ForegroundColor White
Write-Host "  2. $originalItemsFile (僅原始 ItemNumber)" -ForegroundColor White
Write-Host ""
