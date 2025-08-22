**สำหรับเพื่อนที่ทำงานเสร็จ อยากอัปเดตขึ้น GitHub (แนะนำทำผ่าน Pull Request)**

**อัปเดตฐานให้ใหม่ก่อน**
**git checkout main**
**git pull --rebase**
ถ้าทำ git pull --rebase แล้วขึ้นแบบนี้ error: cannot pull with rebase: You have unstaged changes.
error: Please commit or stash them. ให้ข้ามไปเลย

**สร้างสาขาสำหรับงานนี้**
**git checkout -b feature/ชื่อฟีเจอร์ #อันนี้ให้ชื่อชื่อฟีเจอร์เป็นของตัวเอง**
โดยที่-**ภูมิ**: ทำการ์ดและการ์ดพิเศษ,
-**ดิววี่**: ทำมอนเตอร์,
-**ปริมมี่**: ทำด่าน,

**เซฟใน Godot แล้ว commit**
**git add .**
**git commit -m "feat: อธิบายสิ่งที่ทำ"**

**push สาขาขึ้นGithub**
**git push -u origin feature/ชื่อฟีเจอร์**

**สำหรับทุกคนในทีม อยากดึงงานล่าสุดลงมา
ปิด Godot ชั่วคราวถ้ากำลังเปิด (ลดโอกาสไฟล์ถูกล็อก)
อัปเดตสาขาหลัก**
**git checkout main**
**git pull --rebase**
เวลาเปิดโปรเจกต์ใน Godot (ถ้ามี asset ใหม่ Godot จะ re-import ให้เอง ไม่ต้อง commit .godot/.import)

**เปิด Pull Request บน GitHub ไปที่สาขา main ขอรีวิวและกด Merge เมื่ออนุมัติ(อันนี้เดี๋ยวทำเอง)**
ลบสาขาที่จบงาน (บน GitHub หรือ)
**git checkout main**
**git pull --rebase**
**git branch -d feature/ชื่อฟีเจอร์,**
**git push origin --delete feature/ชื่อฟีเจอร์**
