import { Form, Select, Modal, List, Avatar, Button } from 'antd';
import "antd/dist/antd.css"
import "../styles/index.css"
import "../styles/food_receipt.css"
import Head from 'next/head'
import Bar from "../components/bar"
import axios from 'axios';
import { useState, useEffect } from 'react';

function MaterialReceipt(props) {
    const [receipts, setReceipts] = useState([]);
    const [markets, setMarkets] = useState([])
    const [materials, setMaterials] = useState([])
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
        await axios.get(`http://localhost:4000/material_receipt`)
            .then(res => {
                setReceipts(res.data);
                setOnce(true)
            })
        await axios.get(`http://localhost:4000/market/active`)
            .then(res => {
                setMarkets(res.data);
                setOnce(true)
            })
        await axios.get(`http://localhost:4000/material`)
            .then(res => {
                setMaterials(res.data);
                setOnce(true)
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
                url : "http://localhost:4000/material_receipt/add",
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
                                Add a new material order
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
                                        {getFieldDecorator('material_id', {
                                            rules: [{ required: true, message: 'Please input your material!' }],
                                        })(
                                            <Select placeholder="Select a material">
                                                {materials.map((index) =>
                                                    <Option value={index.material_id} key={index.material_id}>{index.name} - {index.price}</Option>
                                                )}
                                            </Select>,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('market_id', {
                                            rules: [{ required: true, message: 'Please input your market!' }],
                                        })(
                                            <Select placeholder="Select a market">
                                                {markets.map((index) =>
                                                    <Option value={index.market_id} key={index.market_id}>{index.market_name}</Option>
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
                                                        url : "http://localhost:4000/material_receipt/delete",
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
                                        title={<p className="list_title">Order: {item.material_receipt_id}</p>}
                                        description={<p className="list_description">Material: {item.name} - Price: {item.total_price}</p>}
                                    />
                                    <p className="list_description">
                                        Market: {item.market_name}
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

export default Form.create()(MaterialReceipt); 