FROM diegosouzapw/omniroute:latest

# إصلاح مشكلة أيقونات Google (المحجوبة في الجزائر)
# نستخدم | كـ delimiter بدل / عشان ما يتعارض مع URLs

# 1) استبدال Google Fonts بـ Cloudflare CDN
RUN find / -type f \( -name "*.html" -o -name "*.js" -o -name "*.css" \) 2>/dev/null \
    -exec sed -i 's|https://fonts.googleapis.com|https://cdnjs.cloudflare.com/ajax/libs|g' {} \;

# 2) استبدال Google Fonts Static بـ Cloudflare
RUN find / -type f \( -name "*.html" -o -name "*.js" -o -name "*.css" \) 2>/dev/null \
    -exec sed -i 's|https://fonts.gstatic.com|https://cdnjs.cloudflare.com/ajax/libs|g' {} \;

# 3) حقن Material Symbols Outlined (CDN بديل) في <head> و body
RUN find / -type f -name "index.html" 2>/dev/null \
    -exec sed -i 's|</head>|<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/material-symbols@0.27.0/index.min.css">\n<script>setTimeout(function(){document.querySelectorAll("[class*=material], span").forEach(function(e){if(getComputedStyle(e).fontFamily.indexOf("Material")!==-1){e.style.fontFamily="Material Symbols Outlined";}});},2000);</script></head>|' {} \;

# 4) تعطيل lazy loading للأيقونات حتى تظهر فوراً
RUN find / -type f \( -name "*.html" -o -name "*.js" \) 2>/dev/null \
    -exec sed -i 's|loading="lazy"|loading="eager"|g' {} \; 2>/dev/null || true

EXPOSE 10000
