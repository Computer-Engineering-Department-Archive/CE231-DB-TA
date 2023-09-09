const express = require('express');
const router = new express.Router();
const db = require('../db');


router.get('/', async (req, res) => {
    try {
        db.query("SELECT * FROM market", function (err, result, fields) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

router.get('/active', async (req, res) => {
    try {
        db.query("SELECT * FROM market WHERE is_active = 1", function (err, result, fields) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

router.post('/add', async (req, res) => {
    try {
        var my_req = "(\"" + req.body.name + "\", " + req.body.is_active + ")"
        var my_query = "INSERT INTO `market` (`name`, `is_active`) VALUES " + my_req
        db.query(my_query, function (err, result) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

router.post('/delete', async (req, res) => {
    try {
        var my_query = "DELETE FROM `market` WHERE market_id = " + req.body.market_id
        db.query(my_query, function (err, result) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

module.exports = router;