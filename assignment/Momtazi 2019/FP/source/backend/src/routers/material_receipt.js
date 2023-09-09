const express = require('express');
const router = new express.Router();
const db = require('../db');


router.get('/', async (req, res) => {
    try {
        db.query("SELECT * FROM material_receipt NATURAL JOIN market JOIN material WHERE material_receipt.material_id = material.material_id", function (err, result, fields) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

router.post('/add', async (req, res) => {
    try {
        var price = 0
        db.query("SELECT price FROM material WHERE material_id = " + req.body.material_id, function (err, result, fields) {
            if (err) throw err;
            price = result[0].price
        })

        var my_req = "(" + price + ", " + req.body.market_id + ", " + req.body.material_id + ")"
        var my_query = "INSERT INTO `material_receipt` (`total_price`, `market_id`, `material_id`) VALUES " + my_req
        db.query(my_query, async function (err, result) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

router.post('/delete', async (req, res) => {
    try {
        var my_query = "DELETE FROM `material_receipt` WHERE material_receipt_id = " + req.body.material_receipt_id
        db.query(my_query, function (err, result) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

module.exports = router;