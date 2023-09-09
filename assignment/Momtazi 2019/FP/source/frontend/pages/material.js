import { Form, Input, Modal, List, Avatar, Button } from 'antd';
import "antd/dist/antd.css"
import "../styles/index.css"
import "../styles/material.css"
import Head from 'next/head'
import Bar from "../components/bar"
import axios from 'axios';
import { useState, useEffect } from 'react';

function Material(props) {
    const [materials, setMaterials] = useState([])
    const [isVisible, setVisible] = useState(false)
    const [confirmLoading, setConfirmLoading] = useState(false)
    const [newMaterial, setMaterial] = useState()
    const [once, setOnce] = useState(false)
    useEffect(() => {
        fetchData();
    }, []);

    const fetchData = async () => {
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
                setMaterial(values)
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
                url : "http://localhost:4000/material/add",
                method : 'POST',
                data : newMaterial,
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
        
    }, [newMaterial])
   
    return(
        <div className="root">
            <Head>
                <title>Restaurant Manager</title>
            </Head>
            <div className="my-layout">
                <div className="left-side">
                    <div className="root_material">
                        <div>
                            <Button className="buttons" type="primary" onClick={() => {setVisible(true)}}>
                                Add a new material
                            </Button>
                            <Modal
                                title="New Material"
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
                                            rules: [{ required: true, message: 'Please input your material name!' }],
                                        })(
                                            <Input
                                                placeholder="Material Name"
                                            />,
                                        )}
                                    </Form.Item>
                                    <Form.Item>
                                        {getFieldDecorator('price', {
                                            rules: [{ required: true, message: 'Please input your material price!' }],
                                        })(
                                            <Input
                                                placeholder="Material Price"
                                            />,
                                        )}
                                    </Form.Item>
                                </Form>
                            </Modal>
                        </div>
                        <List
                            itemLayout="horizontal"
                            dataSource={materials}
                            renderItem={item => (
                                <List.Item
                                    actions={[<Button type="link" onClick={() => {
                                                    axios({
                                                        url : "http://localhost:4000/material/delete",
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
                                        avatar={<Avatar className="material_list_avatar" src="/material_avatar.png" />}
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

export default Form.create()(Material); 