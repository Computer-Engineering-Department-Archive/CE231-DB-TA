const express = require('express');
const router = new express.Router();
const db = require('../db');


router.get('/', async (req, res) => {
    try {
        db.query("SELECT * FROM address, customer WHERE address.customer_id = customer.customer_id", function (err, result, fields) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

router.post('/add', async (req, res) => {
    try {
        var my_req = "(\"" + req.body.name + "\", \"" + req.body.address_str + "\", \"" + req.body.phone_number + "\", " + req.body.customer_id + ")"
        var my_query = "INSERT INTO `address` (`name`, `address_str`, `phone_number`, `customer_id`) VALUES " + my_req
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
        var my_query = "DELETE FROM `address` WHERE address_id = " + req.body.address_id
        db.query(my_query, function (err, result) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

module.exports = router;