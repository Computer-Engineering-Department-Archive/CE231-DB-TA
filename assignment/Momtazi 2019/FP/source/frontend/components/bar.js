import { Button } from 'antd'
import "antd/dist/antd.css"
import "../styles/bar.css"

function Bar() {
    return(
        <div className="root_bar">
            <div className="receipt_div">
                <Button type="danger" className="receipt_button" href="./food_receipt">
                    Food Orders
                </Button>
                <Button type="primary" className="report_button">
                    Report
                </Button>
            </div>
            <Button type="danger" className="bar_buttons" href="./address">
                Addresses
            </Button>
            <Button type="danger" className="bar_buttons" href="./customer">
                Customers
            </Button>
            <Button type="danger" className="bar_buttons" href="./delivery">
                Deliveries
            </Button>
            
            <Button type="danger" className="bar_buttons" href="./food">
                Foods
            </Button>

            
            <Button type="danger" className="bar_buttons" href="./market">
                Markets
            </Button>
            <Button type="danger" className="bar_buttons" href="./material">
                Materials
            </Button>

            <Button type="danger" className="bar_buttons" href="./log">
                Logs
            </Button>
            <div className="receipt_div">
                <Button type="danger" className="receipt_button" href="./material_receipt">
                    Material Orders
                </Button>
                <Button type="primary" className="report_button">
                    Report
                </Button>
            </div>
        </div>
    )
    
}

export default Bar