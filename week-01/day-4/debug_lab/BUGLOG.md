# BUGLOG - save_day.sh

## Bug 1: $msg بدون کوتیشن
- Symptom: Commit ساخته نمی‌شه یا پیام سر اولین فاصله بریده می‌شه.
- Cause: در git commit -m $msg، بش متن رو سر فاصله‌ها می‌شکنه و git فقط کلمه‌ی اول رو پیام می‌گیره.
- Fix: git commit -m "$msg"
- Why hidden: اسکریپت set -e نداشت و بعد از خطا ادامه می‌داد.

## Bug 2: شاخه‌ی master به جای main
- Symptom: Push شکست می‌خوره و چیزی به GitHub نمی‌رسه.
- Cause: شاخه‌ی ما main ـه ولی اسکریپت به master Push می‌کرد.
- Fix: git push -q origin main
- Why hidden: گزینه‌ی -q خطاها رو کم‌صدا می‌کرد و اسکریپت متوقف نمی‌شد.

## Bug 3: فاصله‌ی اول خط‌های .gitignore
- Symptom: .env و .venv نادیده گرفته نمی‌شن.
- Cause: خط‌های داخل heredoc با فاصله شروع می‌شدن و git فاصله رو جزء الگو حساب می‌کنه، پس " .env" با ".env" فرق داره.
- Fix: خط‌ها بدون هیچ فاصله‌ای از اول خط نوشته شدن.
- Why hidden: فایل توی ادیتور درست به نظر می‌رسید.

## Bug 4: git add -A قبل از ساخته شدن .gitignore
- Symptom: .env و .venv وارد Staging و Commit می‌شن و رمزها لو می‌رن.
- Cause: ترتیب کارها غلط بود. add اجرا می‌شد وقتی هنوز لیست «نذار» وجود نداشت.
- Fix: اول write_gitignore، بعد git add -A.
- Why hidden: git add -A هیچ خروجی‌ای چاپ نمی‌کنه.

## ریشه‌ی saved الکی
- اسکریپت set -euo pipefail نداشت و آخرین دستورش echo بود، پس کد خروج همیشه صفر بود.
- Fix: set -euo pipefail اول اسکریپت.