const express = require('express');
const router = new express.Router();
const db = require('../db');

router.get('/', async (req, res) => {
    try {
        db.query("((SELECT * FROM address_log) union (SELECT * FROM customer_log) union (SELECT * FROM delivery_log) union \
        (SELECT * FROM food_log) union (SELECT * FROM material_log) union (SELECT * FROM market_log) union \
        (SELECT * FROM food_receipt_log) union (SELECT * FROM material_receipt_log)) ORDER BY log_time", 
        function (err, result, fields) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

module.exports = router;