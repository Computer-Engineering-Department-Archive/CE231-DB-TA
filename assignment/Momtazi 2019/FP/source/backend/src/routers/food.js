const express = require('express');
const router = new express.Router();
const db = require('../db');


router.get('/', async (req, res) => {
    try {
        db.query("SELECT * FROM food", function (err, result, fields) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

router.post('/add', async (req, res) => {
    try {
        var my_req = "(\"" + req.body.name + "\", \"" + req.body.price + "\")"
        var my_query = "INSERT INTO `food` (`name`, `price`) VALUES " + my_req
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
        var my_query = "DELETE FROM `food` WHERE food_id = " + req.body.food_id
        db.query(my_query, function (err, result) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

module.exports = router;