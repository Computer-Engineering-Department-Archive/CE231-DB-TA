const express = require('express');
const router = new express.Router();
const db = require('../db');


router.get('/', async (req, res) => {
    try {
        db.query("SELECT * FROM food_receipt NATURAL JOIN food", function (err, result, fields) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

router.post('/add', async (req, res) => {
    try {
        var serve = "inside"
        if ('address_id' in req.body) serve = "outside"
        
        var price = 0
        db.query("SELECT price FROM food WHERE food_id = " + req.body.food_id, function (err, result, fields) {
            if (err) throw err;
            price = result[0].price
        })

        var customer = null
        var address = null
        var delivery = null
        await new Promise(resolve => {
            if ('customer_id' in req.body) customer = req.body.customer_id
            if ('address_id' in req.body) address = req.body.address_id
            if ('delivery_id' in req.body) delivery = req.body.delivery_id
            setTimeout(() => resolve(), 2000);
        })
        
        if (address != null) {
            if (delivery === null) {
                res.status(400).send({ error: "This order should have a delivery!" });
            }
        }

        var my_req = "(" + price + ", \"" + serve + "\", " + customer + ", " + address + ", " + delivery + ", " + req.body.food_id + ")"
        var my_query = "INSERT INTO `food_receipt` (`total_price`, `serve_place`, `customer_id`, `address_id`, `delievery_id`, `food_id`) VALUES " + my_req
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
        var my_query = "DELETE FROM `food_receipt` WHERE receipt_id = " + req.body.receipt_id
        db.query(my_query, function (err, result) {
            if (err) throw err;
            res.send(result)
        });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

module.exports = router;