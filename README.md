สำหรับเพื่อนที่ทำงานเสร็จ อยากอัปเดตขึ้น GitHub (แนะนำทำผ่าน Pull Request)

อัปเดตฐานให้ใหม่ก่อน
git checkout main
git pull --rebase
สร้างสาขาสำหรับงานนี้
git checkout -b feature/ชื่อฟีเจอร์
เซฟใน Godot แล้ว commit
git add .
git commit -m "feat: อธิบายสิ่งที่ทำ"
push สาขาขึ้นรีโมต
git push -u origin feature/ชื่อฟีเจอร์
เปิด Pull Request บน GitHub ไปที่สาขา main ขอรีวิวและกด Merge เมื่ออนุมัติ
ลบสาขาที่จบงาน (บน GitHub หรือ)
git checkout main
git pull --rebase
git branch -d feature/ชื่อฟีเจอร์
git push origin --delete feature/ชื่อฟีเจอร์
สำหรับทุกคนในทีม อยากดึงงานล่าสุดลงมา

ปิด Godot ชั่วคราวถ้ากำลังเปิด (ลดโอกาสไฟล์ถูกล็อก)
อัปเดตสาขาหลัก
git checkout main
git pull --rebase
เปิดโปรเจกต์ใน Godot (ถ้ามี asset ใหม่ Godot จะ re-import ให้เอง ไม่ต้อง commit .godot/.import)
