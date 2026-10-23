# CO2008_Computer_Architechture_Lab

# Lab 1 – Arithmetic instructions (Các lệnh số học)

- Đề bài: <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/CA_Lab_1.pdf>
- Báo cáo: <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/report/L01_2510249_Lab1.pdf>

## Bài 1 – In "Hello, &lt;name&gt;!"

Nhập một tên (chuỗi) và in ra `Hello, <name>!`. Ví dụ nhập `John` thì in ra `Hello, John!`.

**Cách làm:**

- Đọc tên bằng `syscall 8` vào bộ đệm `name` 50 byte (`$a1 = 50`, đọc tối đa 49 ký tự). Đề không yêu cầu lời nhắc nên chương trình đọc tên ngay.
- **Vấn đề:** `syscall 8` tự thêm ký tự xuống dòng `'\n'` (mã ASCII 10) vào sau tên. Ví dụ nhập `John` thì bộ nhớ chứa `"John\n\0"`, nếu in thẳng thì dấu `!` bị đẩy xuống dòng dưới.
- **Xóa `'\n'` bằng vòng lặp `loop`** (giống ví dụ String Copy ở chương 2), `$s0` trỏ tới ký tự đang xét, `$t1 = 10`:
  - `lbu $t0, 0($s0)`: đọc ký tự hiện tại.
  - Gặp `'\0'` (`beq $t0, $0, print`): chuỗi đã hết mà không có `'\n'` (khi nhập đủ 49 ký tự), nhảy tới phần in.
  - Gặp `'\n'` (`beq $t0, $t1, change`): nhảy tới `change`, ghi `'\0'` vào vị trí đó bằng `sb $zero, 0($s0)`, chuỗi kết thúc ngay sau tên.
  - Nếu không: `addi $s0, $s0, 1` sang ký tự kế tiếp rồi `j loop`.
- In lần lượt `"Hello, "`, `name` và `"!"` bằng `syscall 4`.

Ví dụ với `John` (bộ nhớ chứa `"John\n\0"`): vòng 1–4 lần lượt gặp `'J'`, `'o'`, `'h'`, `'n'` nên chỉ sang ký tự kế; vòng 5 gặp `'\n'` ở `name[4]`, ghi `'\0'` vào đó và chuỗi thành `"John"`.

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/file_asm/ex1_lab1.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/video/video_ex1_lab1.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1tLy7BGXtTx7sZRRVEhPpJ_5Q2frk9xN_/view?usp=drive_link>

## Bài 2 – Nhập mảng 5 phần tử và in theo chỉ số

Nhập mảng 5 số nguyên với lời nhắc `Please input element 0:`, `Please input element 1:`, …, sau đó nhập chỉ số (0 đến 4) với lời nhắc `Please enter index:` và in ra phần tử tương ứng. Ví dụ mảng 5, 10, 15, 20, 25: nhập chỉ số 1 thì in `10`, nhập 4 thì in `25`.

**Cách làm:**

- Dành mảng `array` 20 byte bằng `.space 20` (5 phần tử, mỗi phần tử 1 word 4 byte). `array` được khai báo đầu tiên trong `.data` nên nằm ở địa chỉ `0x10010000`, chia hết cho 4, dùng được `lw`/`sw`.
- **Nhập mảng bằng vòng lặp `input`:** `$t0` là biến đếm (bắt đầu từ 0), `$t1` là con trỏ tới phần tử đang nhập (bắt đầu từ `array`). Mỗi vòng:
  - In lời nhắc gồm 3 phần: `"Please input element "`, số thứ tự `$t0` (`syscall 1`) và `": "`.
  - Đọc số bằng `syscall 5` (kết quả trong `$v0`) và lưu vào phần tử hiện tại bằng `sw $v0, 0($t1)`.
  - Tăng biến đếm thêm 1 và con trỏ thêm 4 byte (`addi`).
  - Nếu đã đủ 5 phần tử (`beq $t0, 5, index`) thì sang phần nhập chỉ số, nếu chưa thì `j input`.
- **Lấy phần tử theo chỉ số (`index`):** đọc chỉ số vào `$t0`. Địa chỉ phần tử là `array + 4 × index`, tính bằng `mul $t0, $t0, 4` rồi `add` với địa chỉ `array`. Đọc phần tử bằng `lw` và in ra bằng `syscall 1`.
- `beq $t0, 5, index` và `mul $t0, $t0, 4` có toán hạng là hằng số nên là lệnh giả: MARS tự nạp hằng số vào `$at` trước rồi mới thực hiện `beq`/`mul`.

| Chỉ số | 4 × chỉ số | Địa chỉ | Giá trị (ví dụ) |
|:---:|:---:|:---:|:---:|
| 0 | 0 | `0x10010000` | 5 |
| 1 | 4 | `0x10010004` | 10 |
| 2 | 8 | `0x10010008` | 15 |
| 3 | 12 | `0x1001000C` | 20 |
| 4 | 16 | `0x10010010` | 25 |

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/file_asm/ex2_lab1.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/video/video_ex2_lab1.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1P2p8AoOpPVansc_Cr52bpzdvOR7om6Vm/view?usp=drive_link>

## Bài 3 – Tính biểu thức F

Nhập lần lượt các số nguyên a, b, c, d (lời nhắc `Insert a: `, `Insert b: `, …) và in thương, số dư của

F = (a + 10) × (b − d) × (c − 2 × a) / (a + b + c),  với a + b + c ≠ 0.

Ví dụ nhập 3, 4, 5, 6 thì in `F = 2, remainder 2`.

**Cách làm:**

- **Nhập a, b, c, d theo đúng thứ tự:** mỗi số in lời nhắc bằng `syscall 4` rồi đọc bằng `syscall 5`. Kết quả nằm trong `$v0` nên được chép ngay sang `$t0`, `$t1`, `$t2`, `$t3` bằng `move`, vì lần `syscall` kế tiếp sẽ ghi đè `$v0`.
- **Tính tử số** (a + 10) × (b − d) × (c − 2a):
  - `$t4 = a + 10` (`addi`), `$t5 = b − d` (`sub`).
  - `$t6 = 2a = a + a` (`add`), `$t7 = c − 2a` (`sub`).
  - Nhân dồn bằng hai lệnh `mul`: `$s0 = $t4 × $t5 × $t7`.
- **Tính mẫu số** `$s1 = a + b + c` bằng hai lệnh `add`.
- **Chia:** `div $s0, $s1` đặt thương vào `LO` và số dư vào `HI`. Lấy ra bằng `mflo $s2`, `mfhi $s3` rồi in theo dạng `F = <thương>, remainder <số dư>`.
- Kiểm tra với ví dụ của đề: (3 + 10)(4 − 6)(5 − 2·3) / (3 + 4 + 5) = 13 · (−2) · (−1) / 12 = 26 / 12, thương 2, dư 2.
- Lưu ý: `div` chia làm tròn về 0, số dư cùng dấu với số bị chia (ví dụ −22 / 6 cho thương −3, dư −4); `mul` chỉ giữ 32 bit thấp của tích.

| Thanh ghi | Nội dung | Thanh ghi | Nội dung |
|---|---|---|---|
| `$t0`, `$t1`, `$t2`, `$t3` | a, b, c, d | `$s0` | tử số |
| `$t4` | a + 10 | `$s1` | mẫu số a + b + c |
| `$t5` | b − d | `$s2` | thương F |
| `$t6`, `$t7` | 2a, c − 2a | `$s3` | số dư |

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/file_asm/ex3_lab1.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/video/video_ex3_lab1.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1v_fMkfPdT52sFFBcKWMghjrk4F4ce2xQ/view?usp=drive_link>

## Bài 4 – In dạng nhị phân 4 bit

Nhập một số nguyên dương nhỏ hơn 16 (lời nhắc `Please enter a positive integer less than 16: `) và in dạng nhị phân 4 bit. Ví dụ nhập 10 thì in `Its binary form is: 1010`.

**Cách làm:**

- Mỗi số 0 ≤ n < 16 viết được duy nhất dưới dạng n = b3·8 + b2·4 + b1·2 + b0, với b_i ∈ {0, 1}.
- Không dùng lệnh dịch bit hay lệnh logic, tách bit bằng cách **chia liên tiếp cho 2** (`div`, `mflo`, `mfhi`), giống cách đổi sang nhị phân bằng tay:
  - Đặt số chia `$t0 = 2` và đọc n vào `$t1`.
  - Chia `$t1` cho 2: số dư (`mfhi`) là một bit, thương (`mflo`) được ghi đè lại vào `$t1` để chia tiếp.
  - Lặp lại 4 lần (viết lần lượt, không dùng vòng lặp): các số dư lần lượt là b0, b1, b2, b3, cất vào `$t2`, `$t3`, `$t4`, `$t5`.
- Bit tìm được theo thứ tự từ thấp lên cao, nên in ngược lại b3, b2, b1, b0 (`$t5`, `$t4`, `$t3`, `$t2`) bằng `syscall 1`. Mỗi bit được in riêng nên các số 0 ở đầu vẫn được giữ, ví dụ n = 1 in ra `0001`.

| Lần chia | Phép chia | Thương (chia tiếp) | Số dư (bit) | Thanh ghi |
|:---:|:---:|:---:|:---:|:---:|
| 1 | 10 ÷ 2 | 5 | b0 = 0 | `$t2` |
| 2 | 5 ÷ 2 | 2 | b1 = 1 | `$t3` |
| 3 | 2 ÷ 2 | 1 | b2 = 0 | `$t4` |
| 4 | 1 ÷ 2 | 0 | b3 = 1 | `$t5` |

In theo thứ tự b3 b2 b1 b0 được `1010`.

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/file_asm/ex4_lab1.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/video/video_ex4_lab1.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1KGB0CBTfQTg5UgRUQdjmOeSvJGzzGNW-/view?usp=drive_link>

## Bài 5 – Đảo ngược mảng 10 phần tử

In ngược mảng 10 số nguyên cho trước. Ví dụ mảng `1, 2, 5, 8, 12, 44, 3, 9, 0, 10` thì in `10, 0, 9, 3, 44, 12, 8, 5, 2, 1`.

**Cách làm:**

- Khai báo mảng `array` bằng `.word` với 10 giá trị như ví dụ của đề. Mỗi phần tử chiếm 4 byte, nên phần tử có chỉ số k nằm ở `array + 4k`; phần tử cuối (chỉ số 9) nằm ở `array + 36`.
- **Bắt đầu từ phần tử cuối:** `$t0 = 9` là chỉ số phần tử đang in, `$t1 = array + 36` là địa chỉ của nó.
- **Vòng lặp in ngược `print`**, mỗi vòng:
  - Đọc phần tử bằng `lw $t2, 0($t1)` và in bằng `syscall 1`.
  - Nếu vừa in xong phần tử đầu tiên (`beq $t0, 0, end`) thì kết thúc.
  - Nếu chưa, in dấu phân cách `", "`, giảm chỉ số đi 1 và lùi địa chỉ 4 byte (`addi` với −1 và −4), rồi `j print`.
- Điều kiện dừng được kiểm tra **sau khi in phần tử** nhưng **trước khi in dấu phẩy**, nên `", "` chỉ nằm giữa các phần tử, không bị thừa ở cuối.

| `$t0` (chỉ số) | `$t1` (địa chỉ) | Phần tử in ra | Sau khi in |
|:---:|:---:|:---:|---|
| 9 | `0x10010024` | 10 | in `", "`, lùi về chỉ số 8 |
| 8 | `0x10010020` | 0 | in `", "`, lùi về chỉ số 7 |
| … | … | … | … |
| 1 | `0x10010004` | 2 | in `", "`, lùi về chỉ số 0 |
| 0 | `0x10010000` | 1 | `$t0 = 0`, kết thúc |

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/file_asm/ex5_lab1.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_1/video/video_ex5_lab1.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1DT-5NySeJlYdpiRQN41K9dITaMOppz-x/view?usp=drive_link>

## Bài 6 – Dung lượng khung hình và thời gian truyền

Hệ thống hiển thị màu: mỗi màu 8 bit, mỗi điểm ảnh (pixel) gồm 3 màu (đỏ, xanh lá, xanh dương), độ phân giải 1280x1024.

- a. Xác định dung lượng tối thiểu của mỗi khung hình (frame).
- b. Xác định thời gian truyền khung hình đó, biết tốc độ mạng là 100 Mbit/s.

**Lời giải:**

a. Dung lượng mỗi khung hình

- Mỗi điểm ảnh cần 3 × 8 = 24 bit.
- Số điểm ảnh trong một khung hình: 1280 × 1024 = 1 310 720.
- Dung lượng = 1280 × 1024 × 24 = 31 457 280 bit = 31 457 280 / 8 = 3 932 160 byte = 3 932 160 / 1024 = 3840 KiB = 3840 / 1024 = 3,75 MiB (≈ 3,93 MB).

**Đáp số:** mỗi khung hình cần tối thiểu 31 457 280 bit = 3 932 160 byte = 3,75 MiB.

b. Thời gian truyền một khung hình

- Tốc độ mạng 100 Mbit/s = 100 × 10⁶ bit/s.
- t = Dung lượng / Tốc độ = 31 457 280 bit / (100 × 10⁶ bit/s) ≈ 0,3146 s ≈ 314,6 ms.

**Đáp số:** t ≈ 0,315 s.

## Bài 7 – Hiệu năng bộ xử lý

Ba bộ xử lý thực thi cùng một tập lệnh: P1 (3 GHz, CPI 1,5), P2 (2,5 GHz, CPI 1,0), P3 (4 GHz, CPI 2,2).

- a. Bộ xử lý nào có hiệu năng cao nhất tính theo số lệnh mỗi giây (IPS)?
- b. Nếu một bộ xử lý thực thi một chương trình trong 10 giây, hãy tìm số lệnh và tổng số chu kỳ đã thực thi.
- c. Nếu thời gian thực thi chương trình giảm 30% thì CPI tăng 20%. Tần số của hệ thống phải là bao nhiêu để đạt được thời gian đó?

**Lời giải:**

Sử dụng các công thức (IC là số lệnh thực thi, f là tần số xung nhịp):

- T_CPU = IC × CPI / f, suy ra IPS = IC / T_CPU = f / CPI
- Số chu kỳ = f × T_CPU, IC = Số chu kỳ / CPI

a. So sánh IPS

- IPS_P1 = 3 × 10⁹ / 1,5 = 2,0 × 10⁹ lệnh/s
- IPS_P2 = 2,5 × 10⁹ / 1,0 = 2,5 × 10⁹ lệnh/s
- IPS_P3 = 4 × 10⁹ / 2,2 ≈ 1,82 × 10⁹ lệnh/s

**Đáp số:** **P2** có hiệu năng cao nhất (2,5 × 10⁹ lệnh/s).

b. Số chu kỳ và số lệnh trong 10 giây

Số chu kỳ = f × 10; số lệnh IC = Số chu kỳ / CPI = IPS × 10.

| Bộ xử lý | f | CPI | Số chu kỳ | Số lệnh IC |
|:---:|:---:|:---:|:---:|:---:|
| P1 | 3 GHz | 1,5 | 3,0 × 10¹⁰ | 2,0 × 10¹⁰ |
| P2 | 2,5 GHz | 1,0 | 2,5 × 10¹⁰ | 2,5 × 10¹⁰ |
| P3 | 4 GHz | 2,2 | 4,0 × 10¹⁰ | ≈ 1,82 × 10¹⁰ |

c. Tần số mới

- Chương trình (số lệnh IC) không đổi; thời gian mới T' = (1 − 0,3) T = 0,7 T; CPI mới CPI' = 1,2 × CPI.
- Từ T = IC × CPI / f: f' = IC × CPI' / T' = IC × 1,2 CPI / (0,7 T) = (1,2 / 0,7) × (IC × CPI / T) = 12/7 × f.
- Vậy tần số phải tăng khoảng 71,4%. Áp dụng cho từng bộ xử lý:
  - f'_P1 = 12/7 × 3 ≈ 5,14 GHz
  - f'_P2 = 12/7 × 2,5 ≈ 4,29 GHz
  - f'_P3 = 12/7 × 4 ≈ 6,86 GHz
