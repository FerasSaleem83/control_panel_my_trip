const express = require('express');
const path = require('path');
const app = express();
const port = 3000;

// خدمة ملفات فلاتر
app.use(express.static(path.join(__dirname, 'build/web')));

// نقطة الدخول
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'build/web/index.html'));
});

// بدء الخادم
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});
