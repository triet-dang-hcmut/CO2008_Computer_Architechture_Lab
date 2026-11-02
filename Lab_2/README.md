# Lab 2 – Branches and procedures (Lệnh rẽ nhánh và thủ tục)

- Đề bài: <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/CA_LAB2.pdf>
- Báo cáo: <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/report/L01_2510249_Lab2.pdf>

## Bài 1 – Làm tròn về bội của 4 gần nhất

Nhập mảng 5 số nguyên (lời nhắc `Please input element 0: `, `Please input element 1: `, …). Phần tử nào không chia hết cho 4 thì đổi thành bội của 4 gần nó nhất, nếu cách đều thì ưu tiên làm tròn xuống. Ví dụ 35 thành 36, 34 và 33 thành 32. In mảng trước và sau khi đổi.

**Cách làm:**

- **Nhập mảng bằng vòng lặp `input`:** dành mảng `array` 20 byte bằng `.space 20`. `$t0` là biến đếm, `$t1` là con trỏ tới phần tử đang nhập. Mỗi vòng in lời nhắc, đọc số bằng `syscall 5`, lưu bằng `sw $v0, 0($t1)`, tăng biến đếm thêm 1 và con trỏ thêm 4 byte. Đủ 5 phần tử (`beq $t0, 5, print_oldarray`) thì sang in mảng ban đầu.
- **In mảng bằng thủ tục `printarray`:** mảng cũ và mảng mới in cùng dạng `<lời nhắc>[a0, a1, a2, a3, a4]`, chỉ khác lời nhắc, nên viết thành một thủ tục dùng chung:
  - Nơi gọi đặt địa chỉ lời nhắc (`"Old array: "` hoặc `"New array: "`) vào `$a1` rồi `jal printarray`. `jal` lưu địa chỉ lệnh kế tiếp vào `$ra`.
  - Thủ tục in lời nhắc và `"["`, cho `$t1` chạy từ `array[0]` tới `$t0 = array + 16` (`array[4]`). Mỗi vòng `loop_printarray` in một phần tử; nếu `$t1 = $t0` thì dừng, nếu chưa thì in `", "` rồi tăng `$t1` thêm 4. Kiểm tra điều kiện dừng **trước** khi in dấu phẩy nên không bị thừa dấu phẩy ở cuối.
  - Cuối thủ tục in `"]"`, xuống dòng rồi `jr $ra` về nơi gọi. `printarray` là thủ tục lá (không gọi thủ tục khác) nên không cần cất `$ra` lên stack.
- **Kiểm tra chia hết cho 4 (`check`/`div_4`):** `$s0 = 4`, với mỗi phần tử x dùng `div $t2, $s0`, lấy thương q bằng `mflo $t3`, số dư r bằng `mfhi $t4`. r = 0 thì giữ nguyên, r ≠ 0 thì sang `change`.
- **Đổi thành bội của 4 gần nhất (`change`):** kết quả có dạng k × 4. `div` chia làm tròn về 0 nên số dư **cùng dấu với số bị chia**: x = 4q + r với r ∈ {1, 2, 3} khi x > 0, r ∈ {−1, −2, −3} khi x < 0.
  - x > 0: hai bội gần nhất là 4q (cách r) và 4(q + 1) (cách 4 − r). r = 1, 2 thì k = q (r = 2 cách đều, ưu tiên làm tròn xuống); r = 3 thì k = q + 1 (`round_up_positive`).
  - x < 0: thương làm tròn về 0 nên 4q lại là bội **lớn hơn** x (cách |r|), bội nhỏ hơn là 4(q − 1). r = −1 thì k = q; r = −2 (cách đều, làm tròn xuống về phía giá trị nhỏ hơn) và r = −3 thì k = q − 1.
  - Tại `save`: `mul $t3, $t3, 4`, ghi lại vào mảng bằng `sw $t3, 0($t1)` rồi xét phần tử kế tiếp.

| x | q | r | Hai bội gần nhất | k | Kết quả |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 35 | 8 | 3 | 32, **36** | q + 1 = 9 | 36 |
| 34 | 8 | 2 | **32**, 36 | q = 8 | 32 |
| 33 | 8 | 1 | **32**, 36 | q = 8 | 32 |
| 32 | 8 | 0 | – | – | 32 (giữ nguyên) |
| −33 | −8 | −1 | −36, **−32** | q = −8 | −32 |
| −34 | −8 | −2 | **−36**, −32 | q − 1 = −9 | −36 |
| −35 | −8 | −3 | **−36**, −32 | q − 1 = −9 | −36 |

Ví dụ nhập 35, 34, 33, 32, 10 thì in `Old array: [35, 34, 33, 32, 10]` và `New array: [36, 32, 32, 32, 8]`.

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/file_asm/ex1_lab2.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/video/video_ex1_lab2.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1BqJv89JMxPq7HVS_rU_Ef0bEJ0wNKMO-/view?usp=sharing>

## Bài 2 – Ước chung lớn nhất và bội chung nhỏ nhất

Nhập hai số nguyên dương a, b (lời nhắc `a = ` và `b = `, có kiểm tra số dương) và in ước chung lớn nhất (GCD) và bội chung nhỏ nhất (LCM). Ví dụ a = 6, b = 45 thì GCD = 3, LCM = 90.

**Cách làm:**

- **Nhập và kiểm tra a, b:** đọc số bằng `syscall 5`, `ble $v0, $zero, error` kiểm tra số vừa nhập ≤ 0 thì nhảy tới `error`, in `"Not Positive Value! Please try again..."` và kết thúc. Hợp lệ thì lưu a vào `$s0`, b vào `$s1`.
- **Tính GCD bằng thuật toán Euclid** GCD(a, b) = GCD(b, a mod b), GCD(a, 0) = a (vòng lặp `loop_gcd`):
  - Chép a, b sang `$t0`, `$t1` để giữ nguyên a, b gốc trong `$s0`, `$s1` (còn dùng để tính LCM).
  - Mỗi vòng: r = `$t0` mod `$t1` (`div` + `mfhi`), rồi `$t0` ← `$t1`, `$t1` ← r.
  - Khi `$t1 = 0` (`beq $t1, $zero, set_gcd`) thì `$t0` là GCD, lưu vào `$s2`.
  - Nếu a < b thì vòng đầu tự đổi chỗ hai số (6 mod 45 = 6 nên (6, 45) thành (45, 6)), không cần so sánh trước.
- **Tính LCM** = a × b / GCD. Nhân a × b trước có thể tràn 32 bit (ví dụ 50000 × 60000 = 3 × 10⁹ > 2³¹ − 1), vì `mul` chỉ giữ 32 bit thấp. Do đó **chia trước rồi nhân**: LCM = (a / GCD) × b. GCD là ước của a nên phép chia luôn chia hết, kết quả không đổi. LCM lưu trong `$s3`.
- In theo dạng `GCD = <GCD>, LCM = <LCM>`.

| Vòng | `$t0` | `$t1` | `$t0` mod `$t1` | `$t0`, `$t1` mới |
|:---:|:---:|:---:|:---:|:---:|
| 1 | 6 | 45 | 6 | 45, 6 |
| 2 | 45 | 6 | 3 | 6, 3 |
| 3 | 6 | 3 | 0 | 3, 0 → dừng, GCD = 3 |

LCM = (6 / 3) × 45 = 90.

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/file_asm/ex2_lab2.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/video/video_ex2_lab2.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1Sm089Q-Gfa0SmiXE5hZQzeVOEk_qr_3y/view?usp=sharing>
