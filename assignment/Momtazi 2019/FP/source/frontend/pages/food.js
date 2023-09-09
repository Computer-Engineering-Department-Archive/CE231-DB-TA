import { Form, Input, Modal, List, Avatar, Button } from 'antd';
import "antd/dist/antd.css"
import "../styles/index.css"
import "../styles/food.css"
import Head from 'next/head'
import Bar from "../components/bar"
import axios from 'axios';
import { useState, useEffect } from 'react';

function Food(props) {
    const [foods, setFoods] = useState([])
    const [isVisible, setVisible] = useState(false)
    const [confirmLoading, setConfirmLoading] = useState(false)
    const [newFood, setFood] = useState()
    const [once, setOnce] = useState(false)
    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        await axios.get(`http://localhost:4000/food`)
            .then(res => {
                setFoods(res.data);
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
                setFood(values)
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
                url : "http://localhost:4000/food/add",
                method : 'POST',
                data : newFood,
                headers : {
                    'Content-Type' : 'application/json'
                }
                }).then(res => {
                    fetchData()
                    props.form.resetFields();
                }).catch(error => {
                    if(error.response) {
                        console.log(error.response);
                    }
            })
        }
        
    }, [newFood])
   
    return(
        <div className="root">
            <Head>
                <title>Restaurant Manager</title>
            </Head>
            <div className="my-layout">
                <div className="left-side">
                    <div className="root_food">
                        <div>
                            <Button className="buttons" type="primary" onClick={() => {setVisible(true)}}>
                                Add a new food
                            </Button>
                            <Modal
                                title="New Food"
                                visible={isVisible}
                                confirmLoading={confirmLoading}
                                onOk={() => {setVisible(false)}}
                                onCancel={() => {setVisible(false)}}
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
                                        {getFieldDecorator('name', {
                                            rules: [{ required: true, message: 'Please input your food name!' }],
                                        })(
                                            <Input
                                                placeholder="Food Name"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('price', {
                                            rules: [{ required: true, message: 'Please input your food price!' }],
                                        })(
                                            <Input
                                                placeholder="Food Price"
                                            />,
                                        )}
                                    </Form.Item>
                                </Form>
                            </Modal>
                        </div>
                        <List
                            itemLayout="horizontal"
                            dataSource={foods}
                            renderItem={item => (
                                <List.Item
                                    actions={[<Button type="link" onClick={() => {
                                                    axios({
                                                        url : "http://localhost:4000/food/delete",
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
                                        avatar={<Avatar className="food_list_avatar" src="/food_avatar.png" />}
                                        title={<p className="list_title">{item.name} - {item.price}</p>}
                                    />
                                </List.Item>
                            )}
                        />
                    </div>
                </div>
                <div className="right-side">
                    <Bar />
                </div>
            </div>
        </div>
    )
}

export default Form.create()(Food); 