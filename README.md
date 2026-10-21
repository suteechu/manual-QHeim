# 🏗️ QHeim Modular BIM System - คู่มือระบบและเอกสารส่งมอบงานฉบับสมบูรณ์ (Master Manual & Handover Guide)

> **🎯 เป้าหมายของเอกสารชุดนี้:**  
> เอกสารชุดนี้ถูกรวบรวมและจัดทำขึ้นเพื่อเป็น **Single Source of Truth** สำหรับระบบโปรแกรมส่วนขยาย **QHeim (SketchUp Ruby Extension & AutoCAD Automation)**:
> 1. 🔰 **สำหรับพนักงานใหม่ (Onboarding Guide):** เริ่มต้นเรียนรู้ตั้งแต่ศูนย์ เข้าใจคอนเซปต์ Modular House, การติดตั้งสภาพแวดล้อม, และขั้นตอนการทำงานจริงตั้งแต่ไฟล์ 2D AutoCAD ไปจนถึงโมเดล 3D และการถอดประกอบวัสดุ (BOM)
> 2. ⚡ **สำหรับคนที่ลืม (Quick Reference & Operator Cheat Sheet):** รวบรวมกฎเหล็ก ลำดับการกดปุ่ม แถบเครื่องมือ และแนวทางแก้ไขปัญหาที่พบบ่อย (Troubleshooting) เปิดดูได้ทันทีไม่ต้องเสียเวลางม
> 3. 🏛️ **สำหรับส่งมอบงาน / สืบทอดสู่คนรุ่นหลัง (Handover & Architecture Guide):** เพื่อให้เมื่อผู้พัฒนางานเดิมสิ้นสุดวาระหรือลาออกไปแล้ว ทีมงานรุ่นถัดไปจะเข้าใจโครงสร้างโค้ด การจัดเก็บไฟล์ ฐานข้อมูล และสามารถดูแล บำรุงรักษา หรือพัฒนาต่อยอดฟังก์ชันใหม่ได้อย่างมั่นคง ปลอดภัย และยั่งยืน

---

## 📑 สารบัญหลัก (Table of Contents)

1. [ภาพรวมระบบและกระบวนการทำงานแบบ End-to-End (System Overview & Pipeline)](#1-ภาพรวมระบบและกระบวนการทำงานแบบ-end-to-end)
2. [🔰 คู่มือสำหรับพนักงานใหม่ (Onboarding & Getting Started Guide)](#2--คู่มือสำหรับพนักงานใหม่-onboarding--getting-started-guide)
3. [⚡ คู่มือสำหรับคนที่ลืม (Quick Reference & Operator Cheat Sheet)](#3--คู่มือสำหรับคนที่ลืม-quick-reference--operator-cheat-sheet)
4. [🏛️ เอกสารส่งมอบงานและสถาปัตยกรรมระบบสำหรับนักพัฒนา (Handover & Developer Architecture)](#4-️-เอกสารส่งมอบงานและสถาปัตยกรรมระบบสำหรับนักพัฒนา-handover--developer-architecture)
5. [📚 สารบัญคู่มือเจาะลึก 7 ระบบหลัก (System Modules Catalog)](#5--สารบัญคู่มือเจาะลึก-7-ระบบหลัก-system-modules-catalog)
6. [🛠️ แนวทางการพัฒนาต่อยอดและการบำรุงรักษา (Future Roadmap & Maintenance)](#6-️-แนวทางการพัฒนาต่อยอดและการบำรุงรักษา-future-roadmap--maintenance)

---

## 1. ภาพรวมระบบและกระบวนการทำงานแบบ End-to-End

ระบบ **QHeim** เป็นส่วนขยายสำหรับงานออกแบบและวิศวกรรมการผลิตบ้านสำเร็จรูปโครงสร้างเหล็กแบบโมดูลาร์ (Modular House BIM Automation) ทำงานร่วมกันระหว่าง **AutoCAD (2D DWG / AutoLISP / VBA)** และ **Trimble SketchUp Pro (Ruby Extension API + LayOut API)** เพื่อเปลี่ยนแบบสถาปัตยกรรม 2D ให้กลายเป็นโมเดล 3D อัจฉริยะที่ถอดแบบรายการวัสดุและคำนวณรหัสสั่งผลิตโรงงาน (BOM: Bill of Materials) ได้อย่างแม่นยำ 100%

### แผนผังการไหลของกระบวนการทำงาน (End-to-End Pipeline)

```mermaid
flowchart TD
    subgraph CAD["1. ฝั่ง AutoCAD (2D CAD AR / LTF)"]
        A1["แบบร่างสถาปัตยกรรม 2D DWG (มม.)<br/>พิกัด WCS 0,0,0 ทุกชั้นตรงกัน"] --> A2["รันคำสั่ง EXPORTLTF (AutoLISP/VBA)"]
        A2 --> A3[("Export Text JSON & Load Schedules<br/>C:/QHeim/DATA/export-text.json")]
    end

    subgraph SKP_CORE["2. ฝั่ง SketchUp: การนำเข้าและโครงสร้างอาคาร"]
        B1["CAD AR Import:<br/>นำเข้า DWG พิกัดเดิม + สร้าง 3D Text ภาษาไทย"] --> B2["Unit Number:<br/>จัดกลุ่มกริดโมดูลาร์ลงเลเยอร์ S-Unit"]
        B2 --> B3["Door Window Name:<br/>ระบุชื่อช่องเปิดและทิศทางบาน _L/_R"]
        B3 --> C1["Structure (Struc):<br/>สร้างเสา-คาน-ตง 3D, ดรอปพื้น, เจาะรูท่อ, Ceiling Joint"]
    end

    subgraph SKP_ENCLOSURE["3. ฝั่ง SketchUp: เปลือกอาคารและงานสถาปัตย์"]
        C1 --> D1["LongleadTime:<br/>สร้างประตู-หน้าต่าง 3D & ถอดรหัส MIM สั่งผลิตล่วงหน้า"]
        C1 --> D2["Exterior Wall:<br/>ติดตั้งเสา Stud, มุม Corner, แผ่น AAFP, กันซึม C3"]
        C1 --> D3["Interior Wall:<br/>ติดตั้งผนังพาร์ทิชัน, เสากรอบช่องเปิด, บล็อกปิดรอยต่อ"]
        C1 --> D4["PartInstall:<br/>คำนวณรหัสทิศทาง 01-12, ติดตั้ง Flashing, ยางกันสั่น"]
    end

    subgraph SKP_MEP["4. ฝั่ง SketchUp: วิศวกรรมระบบอาคาร (MEP & LayOut)"]
        D1 & D2 & D3 & D4 --> E1["Shaft & Floor Area:<br/>ลงทะเบียนพิกัดกริดยูนิต ix-iy และชาร์ป"]
        E1 --> E2["EE System:<br/>เดินสายไฟแสงสว่าง, เต้ารับ, แอร์ CDU/FCU, สื่อสาร COMMU"]
        E2 --> E3["Trimble LayOut Export:<br/>สร้าง Scene 2D Top-View & พิมพ์แบบ A3 (Scale 1:70)"]
    end

    subgraph OUTPUT["5. ผลลัพธ์และระบบโรงงาน (Factory Integration)"]
        C1 & D1 & D2 & D3 & D4 & E2 --> F1[("Excel & CSV BOM Exports:<br/>- Job Order.xlsx (สรุปยอดสั่งผลิตโรงงาน)<br/>- Recheck.xlsx (ตรวจสอบความถูกต้อง)<br/>- File Upload.csv (อัปโหลดเข้า ERP/SAP)")]
    end
```

---

## 2. 🔰 คู่มือสำหรับพนักงานใหม่ (Onboarding & Getting Started Guide)

ยินดีต้อนรับสู่ทีมงาน QHeim! หากคุณเพิ่งเริ่มเข้ามาร่วมงาน กรุณาทำตามขั้นตอนต่อไปนี้ตามลำดับ:

### 2.1 สิ่งที่ต้องเตรียมและติดตั้งในเครื่องคอมพิวเตอร์ (Prerequisites)
1. **Windows 10 หรือ Windows 11 (64-bit)**
2. **AutoCAD (เวอร์ชัน 2020 ขึ้นไป):** ต้องเปิดใช้งาน Visual LISP / ActiveX ได้
3. **Trimble SketchUp Pro (เวอร์ชัน 2021 ขึ้นไป):** แนะนำเวอร์ชันที่รองรับ Ruby 2.7+ (เช่น SketchUp 2022-2024)
4. **Microsoft Excel:** สำหรับเปิดไฟล์คำนวณและตรวจสอบ BOM
5. **โปรแกรมส่วนขยาย QHeim:**
   * นำโฟลเดอร์หลักไปวางไว้ที่ `C:\QHeim\` (ห้ามเปลี่ยนไดรฟ์หรือชื่อโฟลเดอร์เด็ดขาด เนื่องจากโค้ดฝัง Root Path ไว้อย่างเป็นระบบ)
   * ติดตั้งไฟล์ตัวเปิด Extension ใน SketchUp โดยนำ `C:\QHeim\Setup\QHeim.rb` (หรือติดตั้งผ่าน `QHeim.rbz`) ไปใส่ในโฟลเดอร์ SketchUp Plugins:
     ```
     %AppData%\SketchUp\SketchUp 202X\SketchUp\Plugins\
     ```
   * เมื่อเปิด SketchUp จะปรากฏแถบเครื่องมือ QHeim Toolbar ทั้งหมดขึ้นมาบนหน้าจอ

### 2.2 โครงสร้างโฟลเดอร์โปรเจกต์งานที่ถูกต้อง
เพื่อป้องกันไฟล์สูญหายและให้ระบบส่งออก LayOut / BOM ทำงานได้ถูกต้องเสมอ ให้สร้างโฟลเดอร์งานตามโครงสร้าง:
```
D:\00_QHeim_Work\
 └── [ชื่อโครงการ หรือ House ID]\
      ├── CAD\          <- เก็บไฟล์ 2D DWG ที่ผ่านการ Clean แล้ว
      ├── Model\        <- เก็บไฟล์ 3D SketchUp (.skp)
      ├── Output\       <- เก็บไฟล์ SKU.layout, File Upload.csv, Excel BOM
      └── Temp\         <- พักไฟล์ชั่วคราว
```

### 2.3 คู่มือทำโปรเจกต์แรกแบบ Step-by-Step (First Project Run-through)

| ลำดับ | ขั้นตอน | เครื่องมือที่ใช้ | สิ่งที่ต้องทำและตรวจเช็ค |
| :---: | :--- | :--- | :--- |
| **Step 1** | **เตรียมไฟล์ CAD** | AutoCAD / `ExportLTF.lsp` | 1. ตรวจสอบหน่วยเป็น มิลลิเมตร (`UNITS = mm`)<br/>2. ย้ายจุดอ้างอิงของทุกชั้นให้อยู่ที่ WCS `0,0,0`<br/>3. รันคำสั่ง `EXPORTLTF` ส่งออกไฟล์ข้อความ `C:/QHeim/DATA/export-text.json` |
| **Step 2** | **นำเข้าแบบสู่ SketchUp** | Toolbar `Import OTF CAD` | 1. กด **Import CAD Original** นำเข้าแบบคงพิกัดเดิม<br/>2. กด **Unit Number** รวมกริดโมดูลาร์ลงเลเยอร์ `S-Unit`<br/>3. กด **Door Window Name** เปลี่ยนชื่อบล็อกช่องเปิดอัตโนมัติ |
| **Step 3** | **สร้างโครงสร้างอาคาร** | Toolbar `Structure (Struc)` | 1. เปิดหน้าต่าง **Setting** กรอก House ID, NFL, Platform<br/>2. ครอบยูนิตกด **Floor 1st/2nd/3rd** สร้างเสา-คาน-พื้น 3D<br/>3. รัน **Bathroom**, **Void**, **Stair**, **Entrance**<br/>4. รัน **Hole SB** เจาะรูท่อ &rarr; รัน **Ceiling Joint** |
| **Step 4** | **สั่งผลิตประตู-หน้าต่างล่วงหน้า** | Toolbar `LongleadTime` | 1. กด **Door 3D** สร้างบานประตู-หน้าต่าง 3D ตามรหัส MIM<br/>2. กด **Export BOM** สรุปรายการสั่งผลิตล่วงหน้าส่งโรงงาน |
| **Step 5** | **ติดตั้งผนังภายนอก-ภายใน** | Toolbar `Exterior` & `Interior` | 1. วางเสา Stud, เสามุม Corner, แผ่น AAFP, ระบบกันซึม C3<br/>2. วางผนังพาร์ทิชันแบ่งห้อง และเสากรอบประตู-หน้าต่าง |
| **Step 6** | **ติดตั้งชิ้นส่วนประกอบและข้อต่อ** | Toolbar `PartInstall` | 1. กดรันคำสั่งคำนวณ Direction Code (01-12)<br/>2. ติดตั้ง Flashing, Guide Pin, ยางกันสั่น, และ Super Sheet |
| **Step 7** | **เดินสายงานระบบไฟฟ้า-แอร์-สื่อสาร** | Toolbar `Electricity (EE)` | 1. กด **Shaft** และ **Floor Area** เป็นลำดับแรก<br/>2. แมปวงจรตารางโหลดผ่าน **EE EQPM Text**<br/>3. เดินสายไฟแสงสว่าง สวิตช์ ปลั๊ก แอร์ CDU/FCU และสายแลน/กล้อง<br/>4. ออกแบบ 2D Shop Drawing ผ่าน **Layout** และถอด **BOM** |

---

## 3. ⚡ คู่มือสำหรับคนที่ลืม (Quick Reference & Operator Cheat Sheet)

ส่วนนี้สรุปข้อผิดพลาด กฎเหล็ก และจุดที่คนทำงานมักหลงลืมหรือทำผิดบ่อยที่สุด:

### ⚠️ 7 กฎเหล็กที่ห้ามทำผิดเด็ดขาด (Critical Golden Rules)

1. **พิกัดจุด Origin (0,0,0) ใน AutoCAD ต้องตรงกันทุกชั้น:**  
   หากพิกัดใน CAD เคลื่อน เมื่อนำเข้า SketchUp ด้วยตัวเลือก Preserve Origin โมเดลชั้น 1, 2, 3 จะไม่ซ้อนทับกัน
2. **ห้ามรันข้ามขั้นตอนในการนำเข้า CAD AR:**  
   ต้องกดตามลำดับ: `Import CAD Original` $\rightarrow$ `Unit Number` $\rightarrow$ `Door Window Name` เท่านั้น
3. **ต้องเจาะรูท่อ (Hole SB) ก่อนรัน Ceiling Joint เสมอ:**  
   หากมีคอมโพเนนต์ `AGAZ*` ค้างอยู่ในโมเดล ระบบ Hole SB จะถูกบล็อกทันทีเพื่อป้องกันคานขยับไม่ได้
4. **ต้องรันปุ่ม Shaft และ Floor Area ก่อนเริ่มเดินสายระบบ EE เสมอ:**  
   เพื่อให้ระบบจำพิกัดกริดยูนิต `ix-iy` และทราบตำแหน่งช่องชาร์ป มิฉะนั้นสายไฟจะไม่ยอมวิ่ง
5. **ห้ามขยับหรือหมุนยูนิตหลังจากรัน Floor Area แล้ว:**  
   หากจำเป็นต้องย้ายยูนิต ต้องกดปุ่ม Floor Area ซ้ำใหม่ทุกครั้งเพื่ออัปเดต Attribute
6. **ปิดโปรแกรม Microsoft Excel ทุกครั้งก่อนกด Export BOM:**  
   หากไฟล์ Excel เช่น `Job Order.xlsx` ถูกเปิดค้างไว้ สคริปต์ Ruby จะเขียนทับไม่ได้และเกิดข้อผิดพลาด Permission Denied
7. **ห้าม Explode กรุ๊ปชั้นในของคอมโพเนนต์มาตรฐาน:**  
   คอมโพเนนต์ของ QHeim มีพจนานุกรม Attribute ซ่อนอยู่ภายใน การระเบิดกรุ๊ปจะทำให้ข้อมูล BOM สูญหาย

---

### 🔍 ตารางแก้ปัญหาด่วน (Troubleshooting Quick Fix)

| อาการที่พบบ่อย | สาเหตุ | วิธีแก้ปัญหาทันที |
| :--- | :--- | :--- |
| **นำเข้า DWG แล้วไม่มีตัวหนังสือภาษาไทยขึ้น** | ไม่ได้รัน VBA/LISP ส่งออก `export-text.json` | เปิด AutoCAD รันคำสั่ง `EXPORTLTF` เลือกส่งออก Text ให้ได้ไฟล์ใน `C:/QHeim/DATA/` แล้วกดนำเข้าใหม่ |
| **กด Door Window Name แล้วชื่อไม่เปลี่ยน** | เลเยอร์ `S-Unit` ยังไม่ถูกสร้าง | ตรวจสอบว่าได้กดปุ่ม `Unit Number` ก่อนหรือไม่ หากยัง ให้กด Unit Number ให้เสร็จก่อน |
| **เจาะรูท่อ Hole SB แล้วระบบฟ้องเตือนสีแดง** | มีชิ้นส่วน Ceiling Joint ค้างอยู่ในโมเดล | ซ่อนหรือลบ Ceiling Joint ชั่วคราว ทำการเจาะรูท่อให้เสร็จเรียบร้อย แล้วจึงค่อยรัน Ceiling Joint ใหม่อีกครั้ง |
| **สายไฟ EE ฟ้องเตือน "Please Set FloorArea"** | ยังไม่ได้กำหนดชั้นและพิกัดยูนิต | ลากครอบโมเดลของชั้นนั้น กดไอคอน **Floor Area** เลือก `fl1`/`fl2`/`fl3` รอขึ้น OK แล้วเริ่มเดินสาย |
| **สายไฟ EE ขึ้นเตือน "cannot find route"** | กล่องโมดูลาร์วางไม่แนบสนิท หรือช่องชาร์ปถูกปิด | เช็คระยะห่างระหว่างยูนิตให้ชิดกันสนิท และตรวจสอบว่าไม่มีวัตถุอื่นบังหน้าช่องชาร์ป |
| **ส่งออก BOM แล้วโปรแกรมค้าง** | เปิดไฟล์ Excel ค้างอยู่ในเครื่อง | ปิดโปรแกรม Excel ทั้งหมด แล้วกลับมากดปุ่ม Export BOM ใหม่อีกครั้ง |
| **ส่งออก LayOut แล้วหน้ากระดาษว่างเปล่า** | ยังไม่ได้สร้าง Scene ใน SketchUp | กดไอคอน **Scene** ใน Toolbar Layout เพื่อสร้างแท็บ FL1-FL3 ก่อน แล้วจึงกดปุ่ม Layout |

---

## 4. 🏛️ เอกสารส่งมอบงานและสถาปัตยกรรมระบบสำหรับนักพัฒนา (Handover & Developer Architecture)

> 📌 **บันทึกสำหรับผู้สืบทอดงาน (To Future Maintainers):**  
> หากผม (ผู้พัฒนางานเดิม) ลาออกไปแล้ว ข้อมูลในส่วนนี้คือพิมพ์เขียว (Blueprint) ทั้งหมดของระบบ เพื่อให้คุณสามารถอ่านโค้ด แก้ไขบั๊ก และพัฒนาฟีเจอร์ใหม่ได้อย่างถูกต้องโดยไม่ต้องเริ่มต้นใหม่จากศูนย์

### 4.1 แผนผังโครงสร้างโฟลเดอร์หลัก (`C:\QHeim\`)

```
C:\QHeim\
├── AutoLISP_ExportLTF\   # สคริปต์ AutoLISP/DCL ฝั่ง AutoCAD (ExportLTF.lsp, ExportLTF.dcl)
├── Comp\                 # คลัง 3D Components ชิ้นส่วนมาตรฐานสำเร็จรูป (.skp)
│   ├── EE\               # คอมโพเนนต์งานระบบไฟฟ้า เช่น shaftbox.skp, ตู้ LC
│   └── PartInstall\      # คอมโพเนนต์ Flashing, Guide Pin, Antivibration Rubber
├── Config\               # ค่าคอนฟิกูเรชันของระบบ
├── DATA\                 # คลัง Master Data, ฐานข้อมูล Excel, และโฟลเดอร์รับส่ง JSON
│   ├── export-text.json  # ไฟล์ JSON แลกเปลี่ยนตัวหนังสือระหว่าง AutoCAD และ SketchUp
│   ├── Data MIM&IM*.xlsx # ฐานข้อมูลรหัสวัสดุและอุปกรณ์มาตรฐานโรงงาน
│   ├── New-A3.layout     # เทมเพลตมาตรฐานสำหรับสร้างแบบ LayOut A3
│   └── *.skp             # ไฟล์ต้นแบบชิ้นส่วนโครงสร้าง (ST Component, Installation Part)
├── EXTERIOR-WALL\        # คลังแผ่นผนังภายนอกและเสา
├── ICON\                 # คลังรูปภาพไอคอนสำหรับปุ่มเมนูและ Toolbar ทั้งหมด (.jpg, .png)
├── Longleadtime\         # ฐานข้อมูลและคอมโพเนนต์ประตู-หน้าต่างสั่งผลิตล่วงหน้า
├── manual\               # ศูนย์รวมคู่มือและเอกสารการทำงานระบบทั้งหมด (Repository นี้)
├── Mat\                  # ไฟล์ Materials และ Textures สำหรับพื้นผิว
├── Ruby\                 # ซอร์สโค้ดภาษา Ruby ทั้งหมดของ Extension (หัวใจหลักของระบบ)
│   ├── CADLTF\           # โมดูลนำเข้าแบบ CAD, JSON Parser, เปลี่ยนชื่อประตู-หน้าต่าง
│   ├── EE\               # โมดูลระบบไฟฟ้า, แอร์, สื่อสาร, Pathfinding, LayOut, BOM EE
│   │   ├── AC\           # สคริปต์ระบบแอร์และอุปกรณ์กำลัง
│   │   ├── Layout\       # สคริปต์สร้าง Single-line และส่งออก LayOut
│   │   └── Light\        # สคริปต์ระบบแสงสว่าง สวิตช์ เต้ารับ มาร์กเกอร์สี
│   ├── Exterior\ & STD\  # โมดูลระบบผนังภายนอก เสา Stud เสามุม Corner
│   ├── Heim_C3Wall\      # โมดูลระบบผนังกันซึม C3
│   ├── Interior\         # โมดูลระบบผนังภายในและพาร์ทิชัน
│   ├── LongleadTime\     # โมดูลระบบประตู-หน้าต่าง 3D และถอดรหัส MIM
│   ├── Struc\            # โมดูลโครงสร้างโมดูลาร์ เสา คาน พื้น รูท่อ
│   ├── Switch\           # โมดูลสวิตช์และชิ้นส่วนเสริม
│   └── *.rb, *.html      # สคริปต์ Controller และหน้าต่าง Dialog หลัก
└── Setup\                # สคริปต์ติดตั้งระบบ และไฟล์ acad.lsp
```

### 4.2 สถาปัตยกรรมโค้ดและการไหลของข้อมูล (Data Architecture & Attribute Schema)

ระบบ QHeim ใช้การสื่อสารข้อมูลระหว่าง Entity ผ่าน **SketchUp Attribute Dictionaries** โดยมีพจนานุกรมสำคัญดังนี้:

```mermaid
classDiagram
    class UnitEntity {
        +Dictionary: "Unit"
        +String FL: "fl1" | "fl2" | "fl3"
        +String Pos: "1-1" | "2-3" (ix-iy)
        +Array Shaft: [s0, s1, s2, s3]
        +String Name: "01", "02", ...
    }

    class EEComponentEntity {
        +Dictionary: "Com"
        +String Floor: "fl1"
        +String IM: "IM_APA_001"
        +Array Unit: [Name, pc0..pc3, center, pos]
        +String UnitID: GUID
        +Dictionary: "REC" / "BOX"
        +String ZONE: "LC1"
    }

    class StructureEntity {
        +Dictionary: "SU_DefinitionPath"
        +String PartName: "AGAZ*", "Beam", "Column"
        +String SubBeamAdjust: Offset Distance
    }

    class WallEntity {
        +Dictionary: "Wall"
        +String Type: "AAFP", "Partition"
        +Float StudSpacing: 225.0 | 332.0
    }

    UnitEntity --> EEComponentEntity : ครอบครองอุปกรณ์
    UnitEntity --> StructureEntity : ประกอบเป็นโครงสร้างยูนิต
    UnitEntity --> WallEntity : แนบผนังรอบยูนิต
```

### 4.3 กฎบัตรการเขียนโค้ดและการแก้ไขโปรแกรม (Coding Conventions & Guidelines)
1. **การกำหนดหน่วยใน Ruby:**  
   SketchUp ภายในใช้หน่วยเป็น **Inches** เสมอ หากต้องการใช้หน่วยเมตริก ให้ใช้ `.m` หรือ `.mm` เสมอ เช่น `332.mm`, `10.mm`
2. **การจัดการ Undo Stack:**  
   ทุกคำสั่งที่สร้างหรือแก้ไขโมเดล ต้องครอบด้วย `model.start_operation("ชื่อคำสั่ง", true)` และ `model.commit_operation` เสมอ เพื่อให้ผู้ใช้สามารถกด `Ctrl+Z` ย้อนกลับได้โดยโมเดลไม่พัง
3. **การจัดการ Entity ปลอดภัย:**  
   ก่อนเข้าถึง Attribute หรือ Component Definition ให้ตรวจสอบ `entity.valid?` และ `entity.is_a?(Sketchup::ComponentInstance)` ทุกครั้งเพื่อป้องกัน `TypeError` หรือ `DeletedEntityError`
4. **ความเข้ากันได้ของระบบภาษาไทย:**  
   ไฟล์โค้ด Ruby และ JSON ทั้งหมดต้องบันทึกด้วยการเข้ารหัส **UTF-8 (without BOM)** เสมอ

---

## 5. 📚 สารบัญคู่มือเจาะลึก 7 ระบบหลัก (System Modules Catalog)

คลิกที่ชื่อระบบเพื่อเปิดอ่านคู่มือฉบับเต็ม ทั้งในรูปแบบ Markdown บน GitHub และไฟล์ Web HTML สวยงาม:

| ระบบย่อย (Subsystem) | รายละเอียดและขอบเขตการทำงาน | ลิงก์ Markdown | ลิงก์ Web HTML |
| :--- | :--- | :---: | :---: |
| **1. CAD AR / CAD LTF** | การเตรียมไฟล์ AutoCAD 2D DWG, การส่งออก Text JSON, การนำเข้าแบบพิกัดเดิม (Preserve Origin), การจัดกลุ่ม `S-Unit`, และการเปลี่ยนชื่อบล็อกช่องเปิดประตู-หน้าต่างอัตโนมัติ | [CAD_AR_Doc.md](CAD_AR_Doc.md) | [CAD_AR_Doc.html](CAD_AR_Doc.html) |
| **2. Structure (Struc)** | ระบบสร้างโครงสร้างโมดูลาร์ 3D (ชั้น 1-3), ปรับระดับพื้น Smartboard, งานระบบห้องน้ำ-บันได-Void-ทางเข้า, งานเจาะท่อ Service Hole (BR/FS/CS/AC), ชิ้นส่วนพิเศษ Setback/Turnbuckle, ข้อต่อเพดาน Ceiling Joint, และการถอด BOM | [Struc_Doc.md](Struc_Doc.md) | [Struc_Doc.html](Struc_Doc.html) |
| **3. Exterior Wall** | ระบบผนังภายนอกสำเร็จรูป AAFP, เสา Stud, เสามุม Corner, เสา Window Set, ระบบกันซึม C3, ระบบตรวจสอบระยะเสา 225/332 มม. อัตโนมัติ, และการถอดรายการวัสดุ | [ExteriorWall_Doc.md](ExteriorWall_Doc.md) | [ExteriorWall_Doc.html](ExteriorWall_Doc.html) |
| **4. Interior Wall** | ระบบผนังภายในและพาร์ทิชันแบ่งห้อง, เสากรอบช่องเปิด, บล็อกปิดรอยต่อระหว่างยูนิต, และการคำนวณถอดแบบโครงคร่าว | [InteriorWall_Doc.md](InteriorWall_Doc.md) | [InteriorWall_Doc.html](InteriorWall_Doc.html) |
| **5. PartInstall** | ระบบชิ้นส่วนติดตั้งและตัวยึด, Flashing, Guide Pin, ยางกันสั่น Antivibration Rubber, Super Sheet, และการคำนวณรหัสทิศทางโมดูลาร์ 01-12 | [PartInstall_Doc.md](PartInstall_Doc.md) | [PartInstall_Doc.html](PartInstall_Doc.html) |
| **6. LongleadTime** | ระบบสร้างโมเดลบานประตูและหน้าต่าง 3D, การจับคู่ชื่อแปลนกับรหัส MIM, และการถอดสรุปรายการวัสดุสำหรับสั่งผลิตล่วงหน้า | [LongleadTime_Doc.md](LongleadTime_Doc.md) | [LongleadTime_Doc.html](LongleadTime_Doc.html) |
| **7. Electricity (EE)** | ระบบไฟฟ้าแสงสว่าง, เต้ารับ, สวิตช์ 1-3 ทาง, ระบบแอร์ CDU/FCU, ระบบสื่อสาร LAN/TV/CCTV/Aiphone, อัลกอริทึม Pathfinding, การสร้างผัง Single-line Loop, ส่งออก LayOut 2D, และการสรุป BOM | [EE_Doc.md](EE_Doc.md) | [EE_Doc.html](EE_Doc.html) |

---

## 6. 🛠️ แนวทางการพัฒนาต่อยอดและการบำรุงรักษา (Future Roadmap & Maintenance)

สำหรับทีมงานรุ่นหลังที่ต้องการปรับปรุง พัฒนา หรือขยายขีดความสามารถของระบบ QHeim:

1. **การเปลี่ยนผ่านจาก AutoCAD VBA สู่ Pure AutoLISP:**  
   สคริปต์ใน `AutoLISP_ExportLTF/` ถูกพัฒนาขึ้นเพื่อทดแทน VBA DVB เดิม เพื่อให้สามารถทำงานบน AutoCAD เวอร์ชันใหม่ๆ (รวมถึงระบบที่ปิดกั้น VBA) ได้อย่างราบรื่น ควรทดสอบและย้ายมาใช้ `ExportLTF.lsp` เป็นหลัก
2. **การอัปเดตรหัสชิ้นส่วนและราคา (Master Data Updates):**  
   เมื่อมีการเปลี่ยนแปลงสเปกวัสดุหรือรหัสสินค้าในโรงงาน ให้อัปเดตที่ตาราง `C:/QHeim/DATA/Data MIM&IM - Component Block.xlsx` ระบบถอด BOM จะดึงข้อมูลล่าสุดไปใช้โดยอัตโนมัติ
3. **การเชื่อมต่อ API ตรงกับระบบ ERP:**  
   ปัจจุบันระบบสร้างไฟล์ `File Upload.csv` เพื่อให้นำไปอัปโหลดแบบ Manual ในอนาคตสามารถพัฒนาโมดูล Ruby ด้วย `Net::HTTP` หรือ REST API เพื่อยิงข้อมูลเข้าสู่ระบบ SAP หรือ MES ของโรงงานได้โดยตรงแบบอัตโนมัติ
4. **การรองรับ SketchUp เวอร์ชันใหม่ในอนาคต:**  
   ตรวจสอบการเปลี่ยนแปลงของ SketchUp Ruby API ในแต่ละปี โดยเฉพาะส่วนของ `Geom::Transformation` และ `Layout::Document` เมื่ออัปเกรดเวอร์ชัน SketchUp ให้ทดสอบการสร้าง Viewport ในไฟล์ LayOut เป็นลำดับแรก

---

> 🏢 **จัดทำโดย:** ทีมพัฒนาระบบ QHeim Automation & BIM Modular Construction  
> 🔗 **Repository:** [https://github.com/suteechu/manual-QHeim.git](https://github.com/suteechu/manual-QHeim.git)  
> 📅 **ปรับปรุงล่าสุด:** ตุลาคม 2026
