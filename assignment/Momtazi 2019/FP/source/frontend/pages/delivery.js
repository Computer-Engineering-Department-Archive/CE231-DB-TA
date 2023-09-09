import { Form, Input, Modal, List, Avatar, Button } from 'antd';
import "antd/dist/antd.css"
import "../styles/index.css"
import "../styles/delivery.css"
import Head from 'next/head'
import Bar from "../components/bar"
import axios from 'axios';
import { useState, useEffect } from 'react';

function Delivery(props) {
    const [deliveries, setDeliveries] = useState([])
    const [isVisible, setVisible] = useState(false)
    const [confirmLoading, setConfirmLoading] = useState(false)
    const [newDelivery, setDelievery] = useState()
    const [once, setOnce] = useState(false)
    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        await axios.get(`http://localhost:4000/delivery`)
            .then(res => {
                setDeliveries(res.data);
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
                setDelievery(values)
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
                url : "http://localhost:4000/delivery/add",
                method : 'POST',
                data : newDelivery,
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
        
    }, [newDelivery])
   
    return(
        <div className="root">
            <Head>
                <title>Restaurant Manager</title>
            </Head>
            <div className="my-layout">
                <div className="left-side">
                    <div className="root_delivery">
                        <div>
                            <Button className="buttons" type="primary" onClick={() => {setVisible(true)}}>
                                Add a new delivery
                            </Button>
                            <Modal
                                title="New Delivery"
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
                                        {getFieldDecorator('f_name', {
                                            rules: [{ required: true, message: 'Please input your first name!' }],
                                        })(
                                            <Input
                                                placeholder="First Name"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('l_name', {
                                            rules: [{ required: true, message: 'Please input your last name!' }],
                                        })(
                                            <Input
                                                placeholder="Last Name"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('identification_number', {
                                            rules: [{ required: true, message: 'Please input your identification number!' }],
                                        })(
                                            <Input
                                                placeholder="Identification Number"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('phone_number', {
                                            rules: [{ required: true, message: 'Please input your phone number!' }],
                                        })(
                                            <Input
                                                placeholder="Phone Number"
                                            />,
                                        )}
                                    </Form.Item>
                                </Form>
                            </Modal>
                        </div>
                        <List
                            itemLayout="horizontal"
                            dataSource={deliveries}
                            renderItem={item => (
                                <List.Item
                                    actions={[<Button type="link" onClick={() => {
                                                    axios({
                                                        url : "http://localhost:4000/delivery/delete",
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
                                        avatar={<Avatar className="delivery_list_avatar" src="/delivery_avatar.png" />}
                                        title={<p className="list_title">{item.f_name} {item.l_name} - {item.identification_number}</p>}
                                        description={<p className="list_description">{item.phone_number}</p>}
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

export default Form.create()(Delivery); 