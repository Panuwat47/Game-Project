**สำหรับเพื่อนที่ทำงานเสร็จ อยากอัปเดตขึ้น GitHub (แนะนำทำผ่าน Pull Request)**
**ก่อนอื่นเปิด terminal ขึ้นมาแล้วพิมพ์ cd Game-Project**
**อัปเดตฐานให้ใหม่ก่อน**<br>
git checkout main<br>
git pull --rebase<br>
**ถ้าทำ git pull --rebase แล้วขึ้นแบบนี้<br> error: cannot pull with rebase: You have unstaged changes.<br>
error: Please commit or stash them.<br> ให้ข้ามไปเลย**<br>

**สร้างสาขาสำหรับงานนี้**<br>
git checkout -b feature/ชื่อฟีเจอร์ #อันนี้ให้ชื่อชื่อฟีเจอร์เป็นของตัวเอง<br>
โดยที่<br>-**ภูมิ**: ทำการ์ดและการ์ดพิเศษ,<br>
-**ดิววี่**: ทำมอนเตอร์,<br>
-**ปริมมี่**: ทำด่าน,<br>

**เซฟใน Godot ก่อนแล้วค่อย commit**<br>
git add .<br>
git commit -m "feat: อธิบายสิ่งที่ทำ"<br>

**push สาขาขึ้นGithub**<br>
git push -u origin feature/ชื่อฟีเจอร์<br>

**สำหรับทุกคนในทีม อยากดึงงานล่าสุดลงมา
ปิด Godot ชั่วคราวถ้ากำลังเปิด (ลดโอกาสไฟล์ถูกล็อก)
อัปเดตสาขาหลัก**<br>
git checkout main<br>
git pull --rebase<br>
เวลาเปิดโปรเจกต์ใน Godot (ถ้ามี asset ใหม่ Godot จะ re-import ให้เอง ไม่ต้อง commit .godot/.import)<br>

**เปิด Pull Request บน GitHub ไปที่สาขา main ขอรีวิวและกด Merge เมื่ออนุมัติ(อันนี้เดี๋ยวทำเอง)**
ลบสาขาที่จบงาน (บน GitHub หรือ)<br>
git checkout main<br>
git pull --rebase<br>
git branch -d feature/ชื่อฟีเจอร์<br>
git push origin --delete feature/ชื่อฟีเจอร์
