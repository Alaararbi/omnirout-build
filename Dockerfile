FROM diegosouzapw/omniroute:latest

# إصلاح مشكلة أيقونات Google (المحجوبة في الجزائر)
# نستبدل Google Fonts/Material Icons بـ Cloudflare CDN البديل
RUN find / -type f \( -name "*.html" -o -name "*.js" -o -name "*.css" \) 2>/dev/null \
    -exec sed -i 's|https://fonts.googleapis.com|https://cdnjs.cloudflare.com/ajax/libs|g' {} \; && \
    find / -type f \( -name "*.html" -o -name "*.js" -o -name "*.css" \) 2>/dev/null \
    -exec sed -i 's|https://fonts.gstatic.com|https://cdnjs.cloudflare.com/ajax/libs|g' {} \;

# إضافة CDN احتياطي لـ Material Icons لو ما اشتغل الاستبدال
RUN find / -type f -name "index.html" 2>/dev/null \
    -exec sed -i 's|</head>|<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/material-symbols/0.27.0/material-symbols-outlined.min.css"><script>setTimeout(()=>{document.querySelectorAll(".material-icons,span").forEach(e=>{if(getComputedStyle(e).fontFamily.includes("Material"))e.style.fontFamily="Material Symbols Outlined"});},2000)</script></head>|' {} \;

# تأكيد على المنفذ
EXPOSE 10000
