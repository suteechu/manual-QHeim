Add-Type -AssemblyName System.Drawing
$width = 48
$height = 48
$bmp = New-Object System.Drawing.Bitmap $width, $height
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::Transparent)
$font = New-Object System.Drawing.Font("Arial", 22, [System.Drawing.FontStyle]::Bold)
$brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 0, 85, 164)) # Blue color matching Heim
$g.DrawString("C3", $font, $brush, 2, 4)
$bmp.Save("C:\QHeim\ICON\M-C3.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
