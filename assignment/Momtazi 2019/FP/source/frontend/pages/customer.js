import { Form, Input, Modal, List, Avatar, Button } from 'antd';
import "antd/dist/antd.css"
import "../styles/index.css"
import "../styles/customer.css"
import Head from 'next/head'
import Bar from "../components/bar"
import axios from 'axios';
import { useState, useEffect } from 'react';

function Customer(props) {
    const [customers, setCustomers] = useState([])
    const [isVisible, setVisible] = useState(false)
    const [confirmLoading, setConfirmLoading] = useState(false)
    const [newCustomer, setCustomer] = useState()
    const [once, setOnce] = useState(false)
    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        await axios.get(`http://localhost:4000/customer`)
            .then(res => {
                setCustomers(res.data);
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
                setCustomer(values)
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
                url : "http://localhost:4000/customer/add",
                method : 'POST',
                data : newCustomer,
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
        
    }, [newCustomer])
   
    return(
        <div className="root">
            <Head>
                <title>Restaurant Manager</title>
            </Head>
            <div className="my-layout">
                <div className="left-side">
                    <div className="root_customer">
                        <div>
                            <Button className="buttons" type="primary" onClick={() => {setVisible(true)}}>
                                Add a new customer
                            </Button>
                            <Modal
                                title="New customer"
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
                                        {getFieldDecorator('mobile_number', {
                                            rules: [{ required: true, message: 'Please input your mobile number!' }],
                                        })(
                                            <Input
                                                placeholder="Mobile Number"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('age', {
                                            rules: [{ required: true, message: 'Please input your age!' }],
                                        })(
                                            <Input
                                                placeholder="Age"
                                            />,
                                        )}
                                    </Form.Item>
                                </Form>
                            </Modal>
                        </div>
                        <List
                            itemLayout="horizontal"
                            dataSource={customers}
                            renderItem={item => (
                                <List.Item
                                    actions={[<Button type="link" onClick={() => {
                                                    axios({
                                                        url : "http://localhost:4000/customer/delete",
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
                                        avatar={<Avatar className="customer_list_avatar" src="/customer_avatar.png" />}
                                        title={<p className="list_title">{item.f_name} {item.l_name} - {item.age}</p>}
                                        description={<p className="list_description">{item.mobile_number}</p>}
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

export default Form.create()(Customer); 