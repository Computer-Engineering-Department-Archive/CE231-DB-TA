const path = require('path');
const express = require('express');
const app = express();
const cors = require('cors');

app.use(express.json());
app.use(cors({
    origin: 'http://localhost:3000',
    credentials: true
}));
app.use(`/address`, require('./routers/address'));
app.use(`/customer`, require('./routers/customer'));
app.use(`/delivery`, require('./routers/delivery'));
app.use(`/food`, require('./routers/food'));
app.use(`/material`, require('./routers/material'));
app.use(`/market`, require('./routers/market'));
app.use(`/food_receipt`, require('./routers/food_receipt'));
app.use(`/material_receipt`, require('./routers/material_receipt'));
app.use(`/log`, require('./routers/log'));

// app.use(`${baseURL}/uploads`, express.static(path.join(__dirname, '../../uploads')))

module.exports = app;