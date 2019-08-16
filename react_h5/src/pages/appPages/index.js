import React, { Component } from "react";
// import './index.css'
import './style.styl'

export class App extends Component {

    render() {
        return (
            <div
                class="searchResult"
            >
                <div
                    class="item"
                >
                    <div class="imagebg">
                        <img class="image" src="https://avatar-qiniu.doctorwork.com/FmwjPD5TrxKW0nwAsn8uUKkPY1qi" alt="商品图片" />
                    </div>
                    <span class="title">
                        护理一生
                    </span>
                    <span class="subtitle">
                        实物商品-新增-设置规格
                    </span>
                    <div class="priceContainer">
                        <span class="price">
                            ￥554.99
                        </span>
                        <span class="discount">
                            0.9折
                        </span>
                    </div>
                    <span class="originalPrice">
                        ￥5555
                    </span>
                </div>
                <div
                    class="item"
                >
                    <div class="imagebg">
                        <img class="image" src="https://avatar-qiniu.doctorwork.com/FmwjPD5TrxKW0nwAsn8uUKkPY1qi" alt="商品图片" />
                    </div>
                    <span class="title">
                        2、护理一生
                    </span>
                    <span class="subtitle">
                        2、实物商品-新增-设置规格
                    </span>
                    <div class="priceContainer">
                        <span class="price">
                            ￥554.99
                        </span>
                        <span class="discount">
                            0.9折
                        </span>
                    </div>
                    <span class="originalPrice">
                        ￥5555
                    </span>
                </div>
            </div>
        )
    }
}