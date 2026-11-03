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

## Bài 3 – Phần tử lớn thứ hai trong mảng

Nhập mảng 10 số nguyên (lời nhắc `Please insert an element: `), tìm giá trị lớn thứ hai và tất cả các chỉ số của nó. Ví dụ mảng 1, 2, 7, -7, 3, 7, 4, 6, 8, 7 thì in `Second largest value is 7, found in index 2, 5, 9`.

Giá trị lớn thứ hai là **giá trị lớn nhất trong các phần tử nhỏ hơn max**, các giá trị trùng nhau chỉ tính một lần (ví dụ có hai số 8 lớn nhất thì giá trị lớn thứ hai vẫn là số nhỏ hơn 8). Nếu mọi phần tử bằng nhau thì không tồn tại giá trị lớn thứ hai, chương trình in `There is no second largest value!`.

**Cách làm:**

- **Nhập mảng (`input`):** dành 40 byte bằng `.space 40`. `$t0` là con trỏ, `$t1` đếm số phần tử đã nhập (từ 1). Mỗi vòng đọc số bằng `syscall 5`, lưu bằng `sw`; `$t1 = 10` thì sang in mảng.
- **In lại mảng (`printarray`)** dạng `Array: [a0, ..., a9]` để dễ kiểm tra, chỉ in `", "` khi chưa phải phần tử cuối.
- **Bước 1 – tìm max (`max`/`loop_max`):** `$s0 = array[0]` (`lw`), duyệt `$t2` từ `array[1]` tới `array[9]`; phần tử x lớn hơn max (`blt $s0, $t3, change_max`) thì max = x.
- **Bước 2 – tìm second và các chỉ số trong một lần duyệt (`second_max`/`loop_second_max`):**
  - `$s1` là second hiện tại, `$t2` là cờ đã có second chưa (ban đầu 0; không gán sẵn second = `array[0]` vì `array[0]` có thể là max).
  - Mảng `index` (`.space 40`) lưu các chỉ số của second; `$s3` là con trỏ ghi, `$s2` đếm số chỉ số. `$t0` trỏ tới `array[i]`, `$t1` là i.
  - Với mỗi x = `array[i]`:
    - x = max: bỏ qua.
    - Chưa có second hoặc x > second (`new_second`): second = x, bật cờ, **xóa danh sách chỉ số cũ** (`$s2 = 0`, `$s3` về `index[0]`) rồi lưu i.
    - x = second (`update_index`): lưu thêm i (`sw $t1, 0($s3)`, tăng `$s2` và `$s3`).
    - x < second: bỏ qua.
  - Duyệt xong mà cờ vẫn bằng 0 (`check`) thì mọi phần tử bằng nhau, nhảy tới `error`.
- **In kết quả (`printvalue`/`loop_printindex`):** in giá trị `$s1`, rồi `$s2` chỉ số đầu của mảng `index` cách nhau bởi `", "`.

| i | x | Xử lý (max = 8) | second | Mảng `index` |
|:---:|:---:|---|:---:|:---:|
| 0 | 1 | chưa có second → second mới | 1 | 0 |
| 1 | 2 | 2 > 1 → second mới, xóa danh sách cũ | 2 | 1 |
| 2 | 7 | 7 > 2 → second mới, xóa danh sách cũ | 7 | 2 |
| 3 | −7 | −7 < 7 → bỏ qua | 7 | 2 |
| 4 | 3 | 3 < 7 → bỏ qua | 7 | 2 |
| 5 | 7 | 7 = second → thêm chỉ số | 7 | 2, 5 |
| 6 | 4 | 4 < 7 → bỏ qua | 7 | 2, 5 |
| 7 | 6 | 6 < 7 → bỏ qua | 7 | 2, 5 |
| 8 | 8 | 8 = max → bỏ qua | 7 | 2, 5 |
| 9 | 7 | 7 = second → thêm chỉ số | 7 | 2, 5, 9 |

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/file_asm/ex3_lab2.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/video/video_ex3_lab2.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1PfZZQQNDgNWt2v2_mCze-GZVa_w_I_hy/view?usp=sharing>

## Bài 4 – Giai thừa (đệ quy)

Nhập một số nguyên không âm và in giai thừa của nó. Ví dụ nhập 5 thì in `120`; nhập -2 thì in `A factorial for your number can not be found`.

**Cách làm:**

- **Nhập và kiểm tra n:** đọc bằng `syscall 5`, `blt $v0, 0, error` kiểm tra n < 0 thì in thông báo lỗi và kết thúc. Hợp lệ thì chép n vào `$s0`, gọi `jal factorial` rồi `j print` để in kết quả `$s1`.
- **Thủ tục đệ quy `factorial`** (tham số n trong `$s0`, kết quả trong `$s1`): factorial(n) = 1 nếu n ≤ 1, ngược lại factorial(n) = n × factorial(n − 1).
  - Đầu thủ tục cấp 8 byte stack (`addi $sp, $sp, -8`), cất `$ra` vào `4($sp)` và n vào `0($sp)`.
  - n ≤ 1 (`bgt $s0, 1, factorial_recursion` không nhảy): `$s1 = 1` rồi trả về (gồm cả 0! = 1).
  - n > 1 (`factorial_recursion`): giảm `$s0` còn n − 1, gọi `jal factorial` để được `$s1 = (n − 1)!`, lấy lại n của lần gọi này bằng `lw $s0, 0($sp)` rồi `mul $s1, $s1, $s0`.
  - Cuối thủ tục (`factorial_return`) khôi phục `$ra`, trả lại 8 byte stack và `jr $ra`.
- **Vì sao cất cả `$ra` và n:** `jal factorial` bên trong ghi đè `$ra`, không cất thì mất địa chỉ quay về (cuối cùng là về `main`). Sau khi lời gọi đệ quy trả về vẫn phải nhân với n, mà trong lúc đệ quy `$s0` đã bị giảm, nên mỗi lần gọi phải cất n của riêng nó.
- **Lưu ý:** `mul` chỉ giữ 32 bit thấp nên kết quả đúng với 0 ≤ n ≤ 12 (12! = 479 001 600); từ 13! trở đi bị tràn số nguyên 32 bit (nhập 13 in ra 1932053504).

| Lời gọi | `$s0` (n) | Cất trên stack | Giá trị trả về (`$s1`) |
|---|:---:|---|---|
| factorial(5) | 5 | `$ra` (về `main`), 5 | 24 × 5 = 120 |
| factorial(4) | 4 | `$ra`, 4 | 6 × 4 = 24 |
| factorial(3) | 3 | `$ra`, 3 | 2 × 3 = 6 |
| factorial(2) | 2 | `$ra`, 2 | 1 × 2 = 2 |
| factorial(1) | 1 | `$ra`, 1 | 1 (vì n ≤ 1) |

File code (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/file_asm/ex4_lab2.asm>\
Video demo (Github): <https://github.com/triet-dang-hcmut/CO2008_Computer_Architechture_Lab/blob/main/Lab_2/video/video_ex4_lab2.mp4>\
Video demo (Google Drive): <https://drive.google.com/file/d/1kuFwUclIoVheWIu7g4CctagLTiQv_LiW/view?usp=sharing>
