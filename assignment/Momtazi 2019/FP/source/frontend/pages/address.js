import { Form, Input, Select, Modal, List, Avatar, Button } from 'antd';
import "antd/dist/antd.css"
import "../styles/index.css"
import "../styles/address.css"
import Head from 'next/head'
import Bar from "../components/bar"
import axios from 'axios';
import { useState, useEffect } from 'react';

function Address(props) {
    const [addresses, setAddresses] = useState([]);
    const [customers, setCustomers] = useState([])
    const [isVisible, setVisible] = useState(false)
    const [confirmLoading, setConfirmLoading] = useState(false)
    const [newAddress, setAddress] = useState()
    const [once, setOnce] = useState(false)
    const { Option } = Select;
    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
        await axios.get(`http://localhost:4000/address`)
            .then(res => {
                setAddresses(res.data);
                setOnce(true)
            })
        await axios.get(`http://localhost:4000/customer`)
            .then(res => {
                setCustomers(res.data);
            })
    };

    const { getFieldDecorator } = props.form;
    const handleAdd = async (e) => {
        setConfirmLoading(true)
        e.preventDefault();
        props.form.validateFields((err, values) => {
            if (!err) {
                console.log('Received values of form: ', values);
                setAddress(values)
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
                url : "http://localhost:4000/address/add",
                method : 'POST',
                data : newAddress,
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
        
    }, [newAddress])
   
    return(
        <div className="root">
            <Head>
                <title>Restaurant Manager</title>
            </Head>
            <div className="my-layout">
                <div className="left-side">
                    <div className="root_address">
                        <div>
                            <Button className="buttons" type="primary" onClick={() => {setVisible(true)}}>
                                Add a new address
                            </Button>
                            <Modal
                                title="New address"
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
                                            rules: [{ required: true, message: 'Please input your address name!' }],
                                        })(
                                            <Input
                                                placeholder="Address name"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('address_str', {
                                            rules: [{ required: true, message: 'Please input your address!' }],
                                        })(
                                            <Input
                                                placeholder="Address"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('phone_number', {
                                            rules: [{ required: true, message: 'Please input your address phone number!' }],
                                        })(
                                            <Input
                                                placeholder="Address phone number"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('customer_id', {
                                            rules: [{ required: true, message: 'Please select a customer!' }],
                                        })(
                                            <Select placeholder="Select a customer">
                                                {customers.map((index) =>
                                                    <Option value={index.customer_id} key={index.customer_id}>{index.f_name} {index.l_name}</Option>
                                                )}
                                            </Select>,
                                        )}
                                    </Form.Item>
                                </Form>
                            </Modal>
                        </div>
                        <List
                            itemLayout="horizontal"
                            dataSource={addresses}
                            renderItem={item => (
                                <List.Item
                                    actions={[<Button type="link" onClick={() => {
                                                    axios({
                                                        url : "http://localhost:4000/address/delete",
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
                                        avatar={<Avatar className="address_list_avatar" src="/address_avatar.png" />}
                                        title={<p className="list_title">{item.f_name} {item.l_name} --> {item.name} ({item.phone_number})</p>}
                                        description={<p className="list_description">{item.address_str}</p>}
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

export default Form.create()(Address); 