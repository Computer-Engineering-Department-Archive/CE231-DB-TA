import { Card, Icon } from 'antd'
import "antd/dist/antd.css"
import "../styles/index.css"
import Head from 'next/head'

import Bar from "../components/bar"

function Home() {
    return(
        <div className="root">
            <Head>
                <title>Restaurant Manager</title>
            </Head>
            <div>
                <div className="header_index">
                    <Icon className="header_icon" type="snippets" theme="filled" />
                    <h2 className="header_title">Restaurant Manager</h2>
                </div>
                <div className="root_index">
                    <Bar />
                </div>
            </div>
        </div>
    )
}

export default Home
