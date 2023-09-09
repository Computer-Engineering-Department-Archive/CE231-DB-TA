import { Form, Select, Modal, List, Avatar, Button } from 'antd';
import "antd/dist/antd.css"
import "../styles/index.css"
import "../styles/food_receipt.css"
import Head from 'next/head'
import Bar from "../components/bar"
import axios from 'axios';
import { useState, useEffect } from 'react';

function FoodReceipt(props) {
    const [receipts, setReceipts] = useState([]);
    const [customers, setCustomers] = useState([])
    const [addresses, setAddresses] = useState([])
    const [deliveries, setDeliveries] = useState([])
    const [foods, setFoods] = useState([])
    const [newReceipt, setReceipt] = useState()
    const [isVisible, setVisible] = useState(false)
    const [alertVisible, setAlert] = useState(false)
    const [resAlert, setResAlert] = useState()
    const [confirmLoading, setConfirmLoading] = useState(false)
    const [once, setOnce] = useState(false)
    const { Option } = Select;
    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        await axios.get(`http://localhost:4000/food_receipt`)
            .then(res => {
                setReceipts(res.data);
                setOnce(true)
            })
        await axios.get(`http://localhost:4000/address`)
            .then(res => {
                setAddresses(res.data);
            })
        await axios.get(`http://localhost:4000/customer`)
            .then(res => {
                setCustomers(res.data);
            })
        await axios.get(`http://localhost:4000/delivery`)
            .then(res => {
                setDeliveries(res.data);
            })
        await axios.get(`http://localhost:4000/food`)
            .then(res => {
                setFoods(res.data);
            })
    };

    const { getFieldDecorator } = props.form;
    const handleAdd = async (e) => {
        setConfirmLoading(true)
        e.preventDefault();
        props.form.validateFields((err, values) => {
            if (!err) {
                console.log('Received values of form: ', values);
                setReceipt(values)
            }
        });
        setTimeout(() => {
            setVisible(false)
            setConfirmLoading(false)
        }, 500);
    };
    useEffect(() => {
        if (once === true) {
            axios({
                url : "http://localhost:4000/food_receipt/add",
                method : 'POST',
                data : newReceipt,
                headers : {
                    'Content-Type' : 'application/json'
                }
                }).then(res => {
                    fetchData()
                    props.form.resetFields();
                }).catch(error => {
                    setAlert(true)
                    setResAlert(error.response.data.error)
            })
        }
        
    }, [newReceipt])
   
    return(
        <div className="root">
            <Head>
                <title>Restaurant Manager</title>
            </Head>
            <div className="my-layout">
                <div className="left-side">
                    <div className="root_food_receipt">
                        <div>
                            <Button className="buttons" type="primary" onClick={() => {setVisible(true)}}>
                                Add a new food order
                            </Button>
                            <Modal
                                title="New order"
                                visible={isVisible}
                                onOk={() => {setVisible(false)}}
                                onCancel={() => {setVisible(false)}}
                                confirmLoading={confirmLoading}
                                footer={[
                                    <Button key="cancel" className="modal_buttons" onClick={() => {setVisible(false)}}>
                                        Cancel
                                    </Button>,
                                    <Button 
                                        key="add" 
                                        className="modal_buttons" 
                                        type="primary" loading={confirmLoading} 
                                        htmlType="submit"
                                        onClick={handleAdd}
                                    >
                                        Add
                                    </Button>,
                                  ]}
                            >
                                <Form>
                                    <Form.Item>
                                        {getFieldDecorator('food_id', {
                                            rules: [{ required: true, message: 'Please input your food!' }],
                                        })(
                                            <Select placeholder="Select a food">
                                                {foods.map((index) =>
                                                    <Option value={index.food_id} key={index.food_id}>{index.name} - {index.price}</Option>
                                                )}
                                            </Select>,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('customer_id', {})(
                                            <Select placeholder="Select a customer">
                                                {customers.map((index) =>
                                                    <Option value={index.customer_id} key={index.customer_id}>{index.f_name} {index.l_name} ({index.mobile_number})</Option>
                                                )}
                                            </Select>,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('address_id', {})(
                                            <Select placeholder="Select a address">
                                                {addresses.map((index) =>
                                                    <Option value={index.address_id} key={index.address_id}>{index.f_name} {index.l_name} ({index.name})</Option>
                                                )}
                                            </Select>,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('delivery_id', {})(
                                            <Select placeholder="Select a delivery">
                                                {deliveries.map((index) =>
                                                    <Option value={index.delivery_id} key={index.delivery_id}>{index.f_name} {index.l_name}</Option>
                                                )}
                                            </Select>,
                                        )}
                                    </Form.Item>
                                </Form>
                            </Modal>
                        </div>
                        <List
                            itemLayout="horizontal"
                            dataSource={receipts}
                            renderItem={item => (
                                <List.Item
                                    actions={[<Button type="link" onClick={() => {
                                                    axios({
                                                        url : "http://localhost:4000/food_receipt/delete",
                                                        method : 'POST',
                                                        data : item,
                                                        headers : {
                                                            'Content-Type' : 'application/json'
                                                        }
                                                    }).then(res => {
                                                        fetchData()
                                                    })
                                                }}
                                            >
                                                Delete
                                            </Button>]}
                                >
                                    <List.Item.Meta
                                        avatar={<Avatar className="receipt_list_avatar" src="/receipt_avatar.png" />}
                                        title={<p className="list_title">Order: {item.receipt_id}</p>}
                                        description={<p className="list_description">Food: {item.name} - Price: {item.total_price}</p>}
                                    />
                                    <p className="list_description">
                                        Serve Place: {item.serve_place}
                                    </p>
                                </List.Item>
                            )}
                        />
                        <Modal
                            title="Error"
                            visible={alertVisible}
                            onOk={() => {setAlert(false)}}
                            onCancel={() => {setAlert(false)}}
                            confirmLoading={confirmLoading}
                            footer={null}
                        >
                            {resAlert}
                        </Modal>
                    </div>
                </div>
                <div className="right-side">
                    <Bar />
                </div>
            </div>
        </div>
    )
}

export default Form.create()(FoodReceipt); 