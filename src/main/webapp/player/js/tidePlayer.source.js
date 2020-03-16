/**
JS:TidePubishPlayer(Source) v1.4.11
2019/06/14 - Smpbo
**/

document.onmousedown = function(e) {
    window.haveClick = true;
}

var tidePlayerVar = {
    version: '1.4.11',
    flashPath: 'swf/v.swf',
    jQurl: 'http://cdn.staticfile.org/jquery/3.0.0/jquery.min.js',
    HLSurl: 'http://cdn.staticfile.org/hls.js/0.10.1/hls.light.min.js',
    adPortal: '{{CHANNEL}}', //'http://127.0.0.1:1337/ad.json?id={{CHANNEL}}',//
    showAdClose: 5, //默认允许显示关闭广告等待时间
    skinImage: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAALwAAAEsCAYAAAB5WNlcAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2RpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDozM0NBQTlERDhBNjZFNTExODk1QjkyQkQ3QTI3Rjc1QSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDoyMEJBMzU2QTRCNzExMUU5QUMyOEM2OEU3MzlGNUI2QSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDoyMEJBMzU2OTRCNzExMUU5QUMyOEM2OEU3MzlGNUI2QSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M1IFdpbmRvd3MiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDpCQUZBNTVCRUI5MTkxMUU1QUY5OEE0Q0ExNTE0RUQzNiIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDpCQUZBNTVCRkI5MTkxMUU1QUY5OEE0Q0ExNTE0RUQzNiIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PtnZM54AACUiSURBVHja7F0HfFRV1r9TSSWFVEIJSUAivUoRcRE+pSyKIiqgK4KFYsV1ccW14afrIquwuhb8dF1xsSALFsBO7xAggIE0AiG9kWSSzGTyvnMyNzB582Yyk0x9c/6/38nLvPfmzr3n/N+5555733sKQRAYgeAvUJIKCER4AoEITyAQ4QkEIrwMMR5kBch2kHwQgW+38/3jXfCbj4IUgmwBCe1oYRFP7nwUpBBkC4i95VXytprLTyCBZudoQTZJnIcSxs8pAakA+Q7kIG9TlMTvBYFsBDkA8gNIEYjRmUpVUJbGJqaDLAGZZMe5aKB/gGx2wu8uBVkJUg4SCTIWZI+Zk/oTyFGQrXaS3aK8ipXj9vBjl8uDfVslCB8mauPNIHWi85D060BmivaHg1SBXABpAnkF5J8gKv5ZinwqTvI7QVaDGEASyMO7Hmu555rEvfnLINeDdENHwbfX8/35/LxN/HsdwSOcnB+AzDIjlLnNbgP5L0iqHWS3uzw4t63yjFY8blteOI07Duy1HubnCzZ+4z6Q10EecpIDIcK3gS9A5oPoQZ4C6Q2y3CykYWYhzXJ+/Cl+/nz+/fZgIcibIF+CLACp5fsFfpGh92vkXvYSv7iUNsh+uTzw3q3Kg2MKEBXsb1Ue9/jWcBO/qANFHnm9hHc3x9Ug27hungF5zMa5d4O8DfIgyFcgw51pWDVxW9Kzz+Rx5zQeT7YF7OL/xi+Ab/j313LSthUyodcN5vHr//D4di4/3olvL3HPeA/IRH6xPQHyb96zbOMEd7g8+M5EIH0+bC3K4/gZ5DDIH81Iv55fJIgPRWR/DySOt60FOXzfbpA5IP8HEgDyqkgfi7ke7+B6DDRzMF7n4d/jg6xX3NhzZPI40xopd/LjWXaWN9XMs9tLdnMc4N9r8fRT7dAZEqAvSFeQzzlhGyQc0yGQYSCr+D48txhkXlvlAaHbW95W3p6nzMip5xdGCz41i+nf4575dt5LtWAmj+MZH/Qu4j2VSiJ+v5v3Ii2O5F6nMgYHrU6SYpBHQTJAdoB0d2LZ1qRJMKHYyvFzwhXYU95P/NxlHazXMl7OT22cpwd5y8bx8byc8fzzy/xzIv+8HiSv5fzwpTv0IFbLg2PjQQTc8s8v88+J/PN6kDyz72hFZbwAMl2i7Akgb4j24XdVNtqmsHOfU8WZnhiv2K9BRoCUcQ8yxcUevoxvy60crxCdZwvYlU/gXegqG+nJTdxbXeD/S6Uk8ft5vDxbGR6MzUsdaO86vh1r1sPFubA8vej856wMIn+WiMv1bQxmBTv3eXUePozHhzP4KBsHby/6SOw+waxb1kscXwbyK49NE7hM5/uWSRj7A1G51qBqxwUe3ZJWliCJs8uTFZxNeHNlvcY9PMaE34PEe7kuxpl5KynPvsLGd/HYtRJez7xcKSh4z2gvWvLReXyL2aECF5anFZ3/ipVsDA5k14j2aR28+HyS8GJg1mIo79oO2+HtPIkUs25ditCqNrz0CokBtXm51nLON3OncDezPmPb4kgW8d4DB+MakN/xzEer8iKe3DkP5G4Qu8uDc6XKW2+WgnyN92TreRbFfKCPod0SdmUOQst79xD+OVakPxzYviTBvz+DPC7a18WXCM94em8yz61+w/Ow3ohIG+OBAXZ8f7Doc7moXClsABnI03Qf8/DoLonzdMw0OTSfE6+Epxqj+HetlgdEliwP9l8ur2LlOGvlTeA2e80sLakSEX6mWU+A5b3LyW6elsQyuvP/5/FwN5uZZlvN8RvPCC00S6Ou9zXCm3vJm7kn2OiFhLeHoI7E4pFtDKgRmFe/iqcRB4Hs4mm+myU88gBOnGc5eV7nPejPbZUH5LZaHpD9WThurbwW0v/R7DMOWu80+7yA17kFD4jIzrinz+UpxtW8nh9K6OMrXvbTzJSTx3RqgDON7O6Jpx+4B/rECwmfwbteJEyh6NgJiRhdjMOiz1eZlWsNTaIQComyhTuECWYZFyTM8/z/RGZahKXkZLs8bgLytiqPT0Q1lwf/tyoPzn2en9OqPNhva9CKZL9dNKg3cgIjZlv5Xg7vCZ7gPdg3bYTBOBexko8nzviqh28BDl4jvJDwO80GYGIsbyPFZuTniAdy5uXagwoeEx9hpkmfpWaDUfMBNOpvmpXxBjO7ABwqD87PtCMLp7LSu4XY+N4oZkqBolc/yz9LeW4MjXApQTXI+zxEu9WXCY8eYA+7svLPm7DVrI5aCa+z3MZ3l/Pwwdxws0Xl2osynt06yrt3nBe4YHZ8He89dtl1Ba0cZ1d5cJ495Y3nGTdzcgfyQev0NnrPDH7xfcZM63uirFxQOKP7H2ZaQHaCOXlpgTNnsS6CDLZx/DUQHcg8J/5mCZ95/M3K8TR+vNTBmdY/2pj53ARSwGWT2SyoufzRzplWEjeLO2L4LnxQgwOp65nj61PciTd57Nxys8cBCU+/vY0yRpqlKN9kBK+Cq0MaXJx0kA+OR3g52VsGZR/wkOQbTl5HMJJ/T8vL2UwU8x/C3829IRodl7QW+4hOMPOBK/1wuv1XnpLTtvEdLT/vV/69lvXsBC+DM2/xwxQSztT9xlNKOHmAM3n/cmH9jfyiLeYpRTFyQXry1J2jFzdmFO7l/+PA6SOeVs3gacs4PnicxM9rmabH8+YRteRPeCQB5mPxNq7+zDQzeMjF9c/hY4SzPHwSA6fJcYIFJ38S21H+dN4ee5ZE/Mxjdgpj/ITw+3iqCScK/sBM099ywXjuycdxr469SRH39ju5599OdPIvwhMIfj1oJRCI8AQCEZ5AIMITCER4AqFDUIQv3UFaIPgsKlaOIw9PIFgDLuqiRDzBZxHx5E6HzicPT6BBK4FAhCcQiPAEgu8NWhWkBoKvwtG0pHrKwDjSGsGvPDylJQk+izkfn6UYnkAgwhMIRHgCEZ5AkPmgldKSBJ/Funt6O0b4yIOrSWsE38U9axz28JSWJPgsHn74YYrhCQQiPIFAhCcQ4QkEGYPSkgSfxpo1jmVpiOwEn4ajz0ZFwmeQ2ggUwxMIRHgCgQhPIBDhCQQiPIFAhCcQiPAEAhGeQCDCEwhEeAKBCE8gEOEJRHgCgQhPIBDhCQQiPIFAhCcQiPAEAhGeQCDCEwhEeAKBCE8gEOEJBCI8gQhPIBDhCQQiPIFAhCcQiPAEAhGeQCDCEwhEeAKBCE8gEOEJBCI8gdAK9FIzgk/D0ZeaqR39AoFAIQ2BQIQnEIjwBAIRnkAgwhMIRHgCoWNQO3LyrX+/5Kl6JoDEgETzbSeQWInzikAaQApBykCKQfI9VemvHu/ssrI9aAuftEeLLdReeiHGgwwA6QOSAhJo5/d6SuyrA8kEOQNyAqSA/Jz/2sObCB8OMopLvBPLDeTGQrmNK3gfl0risn/Zo92E3xhZ75QKzCgPQC8wGWSIG73VDC5HQbZAW845qS0eYyfZwz57eMzDQ2USYTMdpJ8j3zMqmLKJCc2DbYPiSv01Ams0jcIVTSqBNdlZHBp1CNTlJGw3g6Jz/dWd+4s91B5QbCDvysbZo0y9QtCUlWYaC/MOMF1Nkba+qkCjryltjiGFJiNrrC2PUAdHViiUqubvaEOi6gLC4g3BofENsT1HKLpEJqu0gsLQhtLRyP2gbjthuwEUXedHRHfYHtV15cbykt9YbXWxVleRp6krz7tsD11xZkRQTMplewRG9qgLiuhhCO4c1xAZfZUiNCDCo/ZQu1m5I2FzJ0iwtXNAC8oaY50m5+wPxqKsncF1pbkRTYY6m4MkJH3L/4bqkojagtPNKYG8g+uYUhukC4xKqohLGadLTJ6gClEFGpTMqrLR6EOhnutByQf8gOx22aOWGTSFxaeMhZm/BledOxRhqK2waQ8kfcv/tYUZEebHtKHRurCewyviksfpYqNTVcFM41Z7qN2kWA1sZoOMsXaOQSGozxekCdnHNwbV5J+IEYwGrTN+u0mvC6q9mB6UdTGdZe9eqw9JGFCcNHCGrnv8YIVGUDRKfAWNPx/qnArbT0HRBhkS3S57lNRcFHJPfRtUevqnGKO+1in20FeXBJWkb0Fhp7TB+qjUG4oTr56qiw7p6hZ7qN2gXMzTLrI20kfFZp/bJWQf+Ty0vjQnzpV1wYuoOu9It2N5R1hGVK/ClBFzqxO7jWRWFI1k6AX1fxuUXCwjsrdpj4LKHLDH+tCKrD0utQdeREXHNncDYRHJY8Aed1fHhnZzqT3ULlYuDoQekeoyoQ9TFFblqI5vXx1SV3w23t2Gx4srfctLcVkxvQsGXf94bWznHo3QtQoSGYRl0I7VchjQtmWPMkOl6tTe90PKz2x3uz3w4joIEtlnfEG/0Q/URmrCXGIPpQuVi3nWJ6WUW8eMmn37/6k9sOGxJE+QvVVd4Pf3f/lwL6wP1stKl/oktKefj5Pduj0URs2JzK3a3evuS/IE2c2Bv79r3bxeWB+sl7PtoXSRcgfxbrNVhfFyLbyUp/75y4XhRSe+TYJRvcobyID1wPr8smFRWHFNvkbiHjBsxyLeLl8ku1V7lBmq1Lu3PBee/es/koRGvXfYA+qB9dmz7YWw8sZLTrWH0gXKxW7zfnHZ2GWevbBXvX/j0u76yotR3kiMhor86L0bHkvIzD+gFizv98Xw737ePl8LYyTtcb46V73niyXdqy+keaU9LuUdid7zxeKECzXnnWYPpZOViwuIlog9CeZvT57dojr1/atJTYa6AG8mCKZAT257Oelk1vdqrLeEZ1nC2+kLZLdqj+yyk6ojG55IatRVeLU9MAV6+MtHk3LKTjnFHkonKhd/fCFIqFi5R49/psrc8XaKt4Qw9oQ4Z39dk3z89CaVhJKxfQt5e72Z7FbtcSZ/vyp909Mp3hLC2BPiHN+0LDmrKK3D9nCmh58rTnVht3nqzBbl+QOfJDNB8K1HgkB9c3d/kJR18aC6ybI7jeft9WZI2iOn9KQyY+vLyUJTk0/ZA+t76tsXk/IhvOmIPZRO8iYtq+paDYiyCg+rs3a+k+RzZL+iZeXp719LKNBdDJAYOI3i7fZG7y5pj4u1F9TpXz+b5Gtkv9wGo155bNOfE0qM1e22h9IJysU00Szx/hJdkfbUtlcTfCWMsRHTBxzZtCysqklyecMs3n5vIrukPSqMNdq0zU8n+EoYYw045kj79tmwKoW+XfZwhoe/mYlyu3WsUXNo6/Od21oD4zNKri2P2P/d8k4NSkE8vR7M2+9NsLSHwqhJ+3ll57bWwPgKcK3O8R1r2mUPZQe9SRITrbLDxUZH969VNpSfj2Yygq4wI/7w3ncVTZY6G8/14A3eXdIeZzN/UladOyQre5Rl/BKfcfYHh+3RUQ8/TVxGYVWOsvjU1u5MhsB2FV3KkwoJpntJFS3sUWaoVObsfl+W9sB2lRuqHLKHsgPeBO+MaTW9i2ulj21/I1QwNmrkqGBsV9ovK0NwgZXoUCrXhye9u6Q9Tu5+J7RJXydLe2C70ne97ZA9OuLhJ4t35J7fJ9QXZ8UxGaO+JDsuN2+vXfpwMyx+v/DSOaEic5es7VGRtTsO2mm3PdpLeLzBd5DYm2Qd/CSM+QEyD60L01t6FdRHpIeqJGmPzP0fO90euz55q/+APkleNfg9C+201x7tJfxI8XfzLh5m9WXnYvyB8NjOCwVpUrr0VF7ewh4lNfmsKveA0+0xdsiAiMNfrB32fyuWJXUJ7+wVT73AdpbUXLTLHu0lfKs7ZXC6N/f4pgDmR8g+9lWgxDS3pwhvYY9zp75zmT0iR0/dozc0NmVv+2zEk/Pu9IqQ6dypb+2yR3sIj0+dajVlXWOs09ZcTI/xJ8Jje2sbLQaDsVw/7oSFPWoFgxZvy3NZ23V1TQ+9sDJ3+pKnT4wa1C/0t28+Gfr768d6NJzF9uoEQ5v2aA/hU8U7cjK2GZ11D6rvZGwM2uyMrUaJQwPcXBULexQWpRuddQ+qLWw/mFYz87Fnz/7948/PP7fo3p7fv78qtU9i906esAe2twDa3ZY92kP4vqLuU1Wcsy+Q+SGKc/cHSXSjqW6uhoQ99rjVHu9+vrlk+Kz7jx89fabm+MaPhr+1/PHE8NAQty9hgHa3aQ9HCY/np5jvaFAImrrS7Ah/JDy2G7Mhot3JzH1PZZa0Bz5KwxP6+NOqd873nDhzv1ajUWR8t274ortmuDXMxXa3ZQ9HDYMxUSvvUVKS0YiPwvBHwmO7S4p/E99hr2HST9J1BSzsUV1X2oiPwvCUTorKKhrvf+61nHnPvHJ66nWjI9I3/WvwDaOGhbrjt7Hdl3SlNu3hKOEtrtiyghPMn2Gl/e7ybBa/U1Ge6xV6+W7HvktTFz6V8cGGbwvefPqR5I2rX+7Ts2ucy8cVlRU5NvXkKOFbZQNwTXJN5XmtPxO+uuqCti09uRAW9qitvOBV9oABbVH/m/+QlptfWH/6638Pf/2pxd1DggJdFvLVVObbtEd7QppWAyR81qM/Ex7ar5UYKLkzpGllD3zWozfq6fG/rskD4h+K6ByqOf3NJ0PnzZjSxRW/A+23aQ9HCd9qnbWRCUp9bVknfyY8tt/In55rTU8uhIU96ivzvdYe2Rcu6u9b/mr2Y6+szpozbVLsoc/fHzhqUD+n6grbb8sejhK+lTIFBVMIjXq1PxMe2y9YehR3kc7CHkZ9ndfbY8MP2ysmzn/81Fc/7ijZ/clbQz79219SYrtEOKXe2H5b9nCU8AGimFHRZDT4NeGx/RI3FbtrmYWFPYx6nc/Y43/f+3dBp8E37K6oqm7M2vbZiBWPLEhQq1SKjhFeZ9MejhJe/OQq9PB+HcNbab+7dGJhD2N9jU/Zo9FoFBav+Hvu6NkPpSUmxAec+e7ToXdMntDueQQr7de0l/CtcpwK7EXVWoM/E95K+92lEwt7qAJCfNYeRiC/RqPukIe30v7L+xzt/urEClaqNI1Nfkx4bL/EU27r3fTzFvZQaYMafU2HuBThD7dMjn/j48/zek++63B9g15oN+Gh/bbs4SjhG1opWGj28I1+zHf08I0Ky9e3NLjp5y3sodIG+ow9/jR/Tty8GZO7pmfmVCffeMdBnKXtaJnYflv2cJTwta0KhzGrNrhLg+FSsd8SHtuPerClJxfCwh4B4QkNNRdPebXObrlhXPiiO2fER4aFahb85bWMXUeOO01f2H5b9nCU8EWtFCwwI75ADN+p5K+A9uslXtBV4qaft7AHvkDMW3WV1K2rdvlD93SbPG5U1LNr1mav/fKbUmf/BrTfpj0cHbQWiGJGFhLeXe/PIU1oWDep9rvr9eoW9ggO7+aV9sAlBemb/jW84lK1AeL0Q64gO2vmY4JNezjq4S1il8jYVHbOjwnfJX6AXXpyESx+Jyy8h1fp5/F7ZsXOv21q/LmLRXW4tABnW135e+ERvWzqqT0hDQ4ALs9cxcT2Uys1gXVyeayeQxkabZAuOqavGjpQ8zttDOJQw8UhTSt7hAXHqDXBEXWefqze+BGDQx6ec1t83149gh99ZXXWT/sOV7t8PBUarescFGXTHo6GNBgbnTHfgW9cC4xOLvdH747vf8WX7Ip25zDG3JWplbRHeK9RHrMHLhF4/4Wnen315op++46drMaVku4ge/PF3nN4m/ZozzJNkYJZY3TPkXX+SPjoniN0EgOkk26uhqU9Eq/xiD1wacC5H7+8Rm8wCMk33nlo5YfrC935+zE9r2nTHu0hvIVBk1InqxQqtV/NuGJ7k/tOkbpv0913xFjYIz5ukEqpDXSbPR6cNT2ar3wMG3HH/UdwqUBldY3RveFloCE+flCb9mjPQqN8nh24vKg+RBWoD4nvV1x94ViCvxAe2xusBlIJFjF1vpurYmGPYIVGH9X3huLi49+41B64tPeRubfFj+if2vmJv/4j6+tfd1d5yh7Y3iCFpk17tPfOk1bvvcduJHHQDL8Ka3oNmiHVfe7zUHUs7dFvmsvsgXcsvfPck4nb3ls5MP1sTm3qtLlHPUl2ROLV0+yyR3sJv088MOvRdRjrFNm9xB/IHtClZ3F3aK/EANJThLewR3RIAg7iXGKPqv1bxmg1amXSjXccxCW+uOLRk/YISxxZHB2aYJc92kt4zAIca5USgtFx0rDZlX7h3YfeUQntFa/7OMb14glI2iN5xFyn22P30RMVo+566AjeuVRWeckr1u0kD59ttz06cjPtFovBa+K1ioCY5EI5kx3bl5Q4TkpvWz1cNQt7xEckKyJSrnWqPa6duzj9YPpvOm+xB7YP2mm3PdpN+I2R9TjBelrsVQZc93A1UyjluWIY2oXtk8j1ngZ95HqyatbskTrmwWqFSitLe2C7sH2O2KOjj0vYLN7RNTylCUbMuXJUcGz/ybnYPnv04CFY1CNaG9HUc8y9srRHr3EP5GL7HLGHsoNeJRs220UFNg0fu1jQhnctlZNyA2N6Fwy55v4mpeUs6k6uB4/Dmj369p0qhHYbLCt7RPYZX9Cn9ySH7eGMB+JsYqJ12YFMrR8x5aUqpSawXg7KVQdHVoyc+lI9tEvcdWK7N3pZdS3tIaj0Qyctq1IHRcjCHkExKRWDxj9aD+1y2B5KJ3gV/JHPLbrSoFh9n989cl6hVBl9Wbl40Q6a9lJlhCpEiiyf8/Z7DazZA+qvHzDlufMKtdan7YEX7cApz1eGCdp22UPpJCVjvrNVzhPXZl/VY1xT8riFOUyhEHxSuzBI7TtxaX630J4NEncW7+Pt9jpYs0cPGH/0//1LOQql0iftgYPUgdNfyo9Vh7fbHs58xt+nTHRDAsZXV/e5ydh9xOxsnyM91Ddx9LyclG6jpG4KLuDt9WZI2qNXVD9jnxuXZfsa6bG+qZOfyekWmtgheyid6FVwXfa74vgRp3uHDLqrMfm6hVm+Et5gPVOuW5w1sN+MRonpamzfu7y9Xgtb9riq25jGfr9fkeUr4Q3Ws//Nr2SlxA/rsD2UTlYyXmmrmei5LFjJ/r2nGPtOeirb2weyWL/UG5/O6df7JqOEcrFdq3k7vR627JEcPdA45NbXs719IIv1G3rbqpykLv2cYg+lC5ScC5v3mShdhN3pVd3HGkfNfOOCt6YscS0Q1q9PwiiDRLoLp67f9/QEkzPt0aNzL+OYWW9d8NaUJa4Fwvp1D010mj2ULlIyrmN4W+xZ8EFBscEJhgkz366KHTA121vW0CtUGj3W53e3rqnC+kkMiLCe7/B2+Rxs2aOLurNh7OQXqpKuX5LtzjX0tqDSBuuxPqP/59kqrJ8z7aF0oZJx4f0qJvGMFszTj7pmof7a2R+cD+t1TZ7HliLA74YnjT537ey1F7A+Enn2lhhxFW+Pz8KmPQSVfkDKTfrr5n58vuuwWXmeWoqAv5sw4q5z4+Z+dAHrI5Fn77A91C5WcvaM8oC/wr+Lmejh/TjSjurUpWH8xGcNheWZWSf3rg2qvZjuthtIgrv2z+8/9kFdbHivJonYsAV4A8Fb0I4iJgO0ZY8IZWDD8KH3GMr6Tcs6c+Q/QSXpW9xmj+j+k/OvGjZHF6kNd6k91G5QchEo+WX4904memN0ywAqISKlKWbqq7oLRcfOZh79AokfIxgbNc73IGoDEL04Zcjtum6xg5rv/2TWk3N7QNZ7ezbGFfaI0UY2RYxerCsZdNvZnPRNQaWnf4xp0tc53R4YQkWlTizu1f9mXXRQnFvsoXaTkrGS/wJFZ8B2FpN4QwY2tlfMINbjpkE1NcY6Pb7suDh7d1BdaW5ERx4Bgo8QCYxKrIhJGqvrddWNKrwdsdmDWFds80ylt04qudMeXQPjWOzIB2tqR9ynx5cdF2XtCMJXQ3bkESD4CBF8ukBs8nW6uNj+Krwd0Z32ULtZ0ftAyRh73QYyVnLAAo0PUwbWD069hRmvvqWmQSE0lJVlGovyDgi6mhJtfWW+Rl9T2qxwuBA0xvqaEFVASA0Quzne04ZE1QWEJxiCQ+MaYroPU3bpkqLqJCgM+Bi65sGO7ekW9CJfettyAU/bozPT1HeOHcKS44bUNFwrNFTXlxvLi39rtoeu/Jymrjyv2R6NdZc0DVUFIZ3C4mvUgZ2b7REY2aMuKLKnIbhzXENEVG9laECkR+2h9oCSsfIfg6J3wPYWZuPN1c3PShQUxqCI3qw7COq0UYG7hVrTtnnGvKQl46AW8L1eiuYtL8IIvsOezAOuI/+vr6UcPWYPbRcW222sT9pD7UFFY2PeAEX3hO1kkCF2VbhZeQpTvNdxHAXZwm+e8Gv4iz3aTXhQjLPqgI17BySSd6tj+P+uQjnvKnfz/53ZFo+B7OHlHt5Kw7/m0h2kH0gKSB/Wsbfi4QANn86VyUwPLTrPCH5rD29949t5kSKwm8UX2eIrxKNAQqx4HTRSDQhOleMTY8u4xyKQPbya8FLdLBGX7NFhKARBIPMR/AZKUgGBCE8gEOEJBCI8gUCEJxCI8AQCEZ5AIMITCER4AoEITyAQ4QkEIjyBQIQnEOEJBCI8gUCEJxCI8AQCEZ5AIMITCER4AoEITyAQ4QkEIjyBQIQnEIjwBCI8geAHUPtjo+fsdM/vrBvn44pSKPBpwdlMEJqI8PLAQpDBzPSE2/dAMsgHtiL7r8z0No5JRHjfxx3M9LLeFjwK8irIiyB6P2j/dJDbQbJA8FWWdRJkx9dWVlIMLw+MFH1WgTwDcghkgMzbPgPkft7mYSCJl48EBPRmQUH7Odl/BBlIhJcHvmTs8su2zDGAk/4Zmbb79yD3gfzAPfuVnh49e0PDL0yni2RDhxaziooFcorf/Z3we5np5V3lEse0ICtAvgAJlFGbp4A8wEzvU1oNUs/3C82evSWM6dRpOztw4EcWHo5v7FbIyej+PmhFL4fvLnqDx/RizATpATKN8dcx+hiuAbkWAxVmei8TvpnvMMjr/Ljp7dpLl0YzpRIv7i5Mrf4FvPxEplKNh89P8O8cIQ8vHxQy02vYb7VCaoz18S1zKT7YtiUg14N0Y6Z3MO3iA/Mr70pNSwtmq1f/h9XVdWHDh5dCOLOZhzGYvK0CmUghjTyxkQ/QDkgcM89a+BLwZWPfMVP6dQmP2esvH12xogebNGk0a2yMbR6g7tmzlGk0NzDTy8rwvavHmY0XFRPh5eHtr+cDWjGQ7FtAwnysTZck9+IA9cUXP2SlpQEsLGwf7LkRyP4LP3o13xaAhBPh5Q3MR9/Ou34xMIPzFR/U+q6NW/LsBkNMcxiTn/8gD2Oq+RlhcjUuEd46nuYixgSQ9T7UDqMk2bHHQs++b99+FhzcknrswrctY5muTDqLRYSXKdDLvymxfwaPib0dSORr+MDzdxCzTzEbi/zQ7NlVKvP3lk7lsTu+IVvNxzSnifD+hcdAPpXY/zrz/hlZzC71YrhsIi3tWfbmmxvYlRnUG808O74OfgwzrZnBc6r4WKYzM6VuifB+hnnMNFFlDozj1zLT9Ly3YhXIg2zBglchVk9tHqCaUo9/Ya0nlNDLJ4IcBPmEmV4nPx8knZkyNbKBmrhsF3Ax2Rxu/BCz/SOZadHZKi+ttwAxO3rpz0DimieV9u49CtunYfsyM2WlEAFmvRimJJ/nF8RqfjGQh/dD5IAsktiPa24ivbjeBy+HMY2NE4HsSOYsNmrUn/hYhIm8/QB+UeOq0QK5GZEI7xj+zSxz9Ej2v3hxnb+7HLNfST0i6bNB8BaVMpBSs/NxUPsQyCk5GlAhCILfsbaDdzwlcLKY5+Ixd59kFiI0wyvueFIo4uBvsdxWPZKHdx/yQf4h2ocrKp/wziheKCSyE+E7ChzwVYn2zWfyWkpMhCdcBs4+rpKI5e8g1RDh5YoPmOUdU3eTWojwco7lfxbtG8+8O0VJhCcVdAgfiT7jrOsMUgsRXq7YKDF4nUBqIcLLFZh/3yUR1hCI8LKFeDVhAvO9WwGJ8AS7cVhi3wBSCxFerkgjwhPh/Qn4INZ8ibCGQISXLYjwRHi/gvgBTjT5RISXfVhjDi2phAgvZ4jX1ISRSojw/oQqUgERXs4Ia8PjE4jwsoJ4kFpOKiHCyxniNGQhqYQIL1doJQifR2ohwssV+Ghp8dPHckgtRHi5YrDEvjRSCxFerhgvMWDNJLUQ4eUK8R1O+NBVSksS4WUJXAbcQ7RvO6mFCC9XzJTYt5nUQoSXIzAzc69o3wmQDFINEV6OmCQRznxKaiHCyxXLRJ9xoPoRqYUIL0eMZ5bpSHxuPC0pIMLLEq9I7PsbqYUIL0fgQHW0aB8+m+YwqYYILzfgIrHXJWL3p0g1RHg54kNmufYdB6q0doYILzs8wEypSHPgMuClpBoivNyA62XWSOxfwOj+VSK8zIDrZb5ilo/e+CeT2WvZifAEnEndwixv0j5BA1UivBw9+x5mefsePlZvMrN8+BKBCO+zuMkK2as42fNJRUR4uQCzMZtAQkT79SC38nCG4KNQkwouA+P0tUx6jTuGL7czy7f2EcjD+yTwhcJnrZAdc+1jQLaSmsjDy8Gr4+yptVdNYvgyjdFzZsjDywS2yP4B9+xEdvLwssFUiX2YgVlAIQx5eDniW9Hn90D6EdnJw8sVc0DuZqZlA9sZpRxlD4UgCKQFAoU0BAIRnkAgwhMIRHgCgQhPIBDhCQQiPIFAhCcQiPAEAhGeQCDCEwhEeAIRnkAgwhMIRHgCgQhPIBDhCQQiPIFAhCcQiPAEAhGeQCDCEwhEeAKBCE8gwhMIRHgCgQhPIPgm/l+AAQD0pwXh6Bc7FQAAAABJRU5ErkJggg==',
    wavImage: 'data:image/gif;base64,R0lGODlhCAAHAIAAADPMAFVVVSH/C1hNUCBEYXRhWE1QPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS41LWMwMTQgNzkuMTUxNDgxLCAyMDEzLzAzLzEzLTEyOjA5OjE1ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOnhtcE1NPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvbW0vIiB4bWxuczpzdFJlZj0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL3NUeXBlL1Jlc291cmNlUmVmIyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ0MgKFdpbmRvd3MpIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjBCQjg0QUVGRDBGMjExRThBNzE1OENCMUM3MDc4QTc1IiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjBCQjg0QUYwRDBGMjExRThBNzE1OENCMUM3MDc4QTc1Ij4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MEJCODRBRUREMEYyMTFFOEE3MTU4Q0IxQzcwNzhBNzUiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MEJCODRBRUVEMEYyMTFFOEE3MTU4Q0IxQzcwNzhBNzUiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4B//79/Pv6+fj39vX08/Lx8O/u7ezr6uno5+bl5OPi4eDf3t3c29rZ2NfW1dTT0tHQz87NzMvKycjHxsXEw8LBwL++vby7urm4t7a1tLOysbCvrq2sq6qpqKempaSjoqGgn56dnJuamZiXlpWUk5KRkI+OjYyLiomIh4aFhIOCgYB/fn18e3p5eHd2dXRzcnFwb25tbGtqaWhnZmVkY2JhYF9eXVxbWllYV1ZVVFNSUVBPTk1MS0pJSEdGRURDQkFAPz49PDs6OTg3NjU0MzIxMC8uLSwrKikoJyYlJCMiISAfHh0cGxoZGBcWFRQTEhEQDw4NDAsKCQgHBgUEAwIBAAAh+QQAAAAAACwAAAAACAAHAAACCYyPGcDtD6N0BQA7',
    appname: 'LiveSphere Player'
};

function tidePlayer(initobj) {

    console.info('%c' + tidePlayerVar.appname, 'color:#aaa;font-size:1.5em;');
    console.info('version %c' + tidePlayerVar.version, 'color:#c00;');

    var writeStyle = function() {
        $('head').append($('<style>').text(
            '._tdp_adi{position:absolute;top:0;left:0;width:100%;height:100%;z-index:50;background:#000 no-repeat center center;background-size:contain;}\
			._tdp_adlm{position:absolute;left:0;top:0;z-index:51;width:100%;height:100%;text-decoration:none;display:block}\
			._tdp_adl{position:absolute;right:10px;bottom:10px;color:#fff;z-index:52;background:rgba(0,0,0,.6);padding:10px;text-decoration:none;font-size:16px;display:block}\
			._tdp_adt,._tdp_adpt{position:absolute;right:10px;top:10px;color:#fff;z-index:52;padding:0 7px;font-size:12px;line-height:24px;border:1px solid #fff;}\
			._tdp_adpt{left:5px;bottom:5px;right:auto;top:auto;}\
			._tdp_adt span,._tdp_adpt span{color:#f00}\
			._tdp_adc{padding:0 4px;font-size:18px;cursor:pointer;display:none;float:right;}\
			._tdp_adc:hover{background:#c00}\
			._tdp_adp{position:absolute;display:none;top:50%;left:50%;z-index:50;}\
			._tdp_adp .box{position:relative;width:100%;height:100%;}\
			._tdp_adp a{display:block;}\
			._tdp_adp img{display:block;margin:0}\
			video::-webkit-media-controls{display:none;}\
			video::-webkit-media-controls-play-button{}\
			video::-webkit-media-controls-volume-slider{}\
			video::-webkit-media-controls-mute-button{}\
			video::-webkit-media-controls-timeline{}\
			video::-webkit-media-controls-current-time-display{}\
			video::-webkit-media-controls-enclosure{overflow:hidden;}\
			video::-webkit-media-controls-panel{width:calc(100%+30px);}\
			video::-webkit-media-controls-start-playback-button{display:none!important;-webkit-appearance:none;}\
			@keyframes _tdp_circle{0%{transform:rotate(0);}to{transform:rotate(360deg);}}\
			@-webkit-keyframes _tdp_circle{0%{-webkit-transform:rotate(0);}to{-webkit-transform:rotate(360deg);}}\
			.wh100{width:100%;height:100%;}\
			._tdp_player{position:relative;background:#000;}\
			._tdp_tip{position:relative;justify-content:center;align-items:center;background:#000;display:-webkit-flex;width:100%;height:100%;color:#fff;font-size:24px;text-align:center;left:0;top:0;z-index:60;}\
			._tdp_tip.hide{display:none;}\
			._tdp_box{position:relative;z-index:1;background:#000;overflow: hidden;}\
			._tdp_poster{position:absolute;top:0;left:0;width:100%;height:100%;z-index:4;background:#000 no-repeat center center;background-size:contain;}\
			._tdp_vbox{width:100%;height:100%;z-index:2;}\
			._tdp_bigbtn{z-index:6;background:url(' + tidePlayerVar.skinImage + ') -111px -101px no-repeat rgba(1,1,1,0);cursor:pointer;}\
			._tdp_bigbtn,._tdp_buffer{position:absolute;top:75%;left:10%;margin:-40px 0 0 -38px;width:75px;height:75px;}\
			._tdp_buffer{z-index:3;overflow:hidden;background:url(' + tidePlayerVar.skinImage + ') -11px -201px no-repeat;animation:_tdp_circle .5s linear 0s infinite;-webkit-animation:_tdp_circle .5s linear 0s infinite;}\
			._tdp_contrl{position:absolute;bottom:0;left:0;z-index:2147483648;width:100%;height:40px;background:rgba(0,0,0,.6);}\
			._tdp_pausebtn,._tdp_playbtn{position:absolute;bottom:7px;left:7px;overflow:hidden;width:27px;height:27px;background:url(' + tidePlayerVar.skinImage + ');background-position:-10px -5px;cursor:pointer;z-index:8;}\
			._tdp_pausebtn{display:none;background-position:-39px -5px;}\
			._tdp_ing{position:absolute;right:95pt;bottom:19px;left:52px;height:3px;background:hsla(0,0%,100%,.3);z-index:7;}\
			._tdp_ing.hide{display:none;}\
			._tdp_ing span{float:left;clear:both;display:block;overflow:hidden;width:0;height:3px;background:#009bff;}\
			._tdp_ing bdo{top:-10px;width:100%;height:23px;}\
			._tdp_ing abbr,._tdp_ing bdo{position:absolute;display:block;}\
			._tdp_ing abbr{left:0;overflow:hidden;margin:-10px 0 0 -9pt;width:24px;height:24px;background:url(' + tidePlayerVar.skinImage + ') -65px -5px;cursor:pointer;transition:all 0.2s linear;}\
			._tdp_ptime{left:52px;}\
			._tdp_ptime,._tdp_ttime{position:absolute;bottom:4px;color:#fff;font-size:10px;}\
			._tdp_ttime{right:95pt;}\
			._tdp_speed{right:110px;bottom:0;height:40px;line-height:40px;cursor:pointer;}\
			._tdp_speed,._tdp_speedlist{position:absolute;overflow:hidden;width:40px;color:#fff;text-align:center;font-size:9pt;}\
			._tdp_speedlist{right:105px;bottom:40px;display:none;padding:5px;background:rgba(0,0,0,.5);}\
			._tdp_speedlist span{display:block;line-height:28px;cursor:pointer;}\
			._tdp_rate{right:70px;bottom:0;height:40px;line-height:40px;cursor:pointer;}\
			._tdp_rate,._tdp_ratelist{position:absolute;overflow:hidden;width:40px;color:#fff;text-align:center;font-size:9pt;}\
			._tdp_ratelist{right:65px;bottom:40px;display:none;padding:5px;background:rgba(0,0,0,.5);}\
			._tdp_ratelist span{display:block;line-height:24px;cursor:pointer;}\
			._tdp_ratelist .n{color:#009bff;font-weight:700;}\
			._tdp_vol,._tdp_volctrl{position:absolute;right:40px;bottom:8px;width:22px;height:20px;background:url(' + tidePlayerVar.skinImage + ') -92px -5px;cursor:pointer;}\
			._tdp_vol{z-index:10;}\
			._tdp_vol.muted{background-position:-116px -206px;}\
			._tdp_volctrl{right:38px;bottom:0px;display:none;width:30px;height:120px;background:none;z-index:9;}\
			._tdp_volctrl .block{position:relative;width:100%;height:80px;background:rgba(0,0,0,.5)}\
			._tdp_volctrl .bg{position:absolute;width:3px;height:60px;left:14px;top:10px;background:hsla(0,0%,100%,.3)}\
			._tdp_volctrl .hand{position:absolute;width:12px;height:12px;border-radius:12px;left:9px;top:10px;background:#009bff;}\
			._tdp_fullbtn{position:absolute;right:8px;bottom:8px;width:19px;height:20px;background:url(' + tidePlayerVar.skinImage + ') -134px -5px;cursor:pointer;}\
			._tdp_wavs{position:absolute;height:100%;width:18px;right:0%;top:0;background:#333;padding-left:1px;z-index:2147483647}\
			._tdp_wavs .w{height:100%;background:#555;width:8px;margin:0 1px 0 0;float:left;position:relative;overflow:hidden;box-shadow:inset 1px 1px 1px rgba(0,0,0,.7);}\
			._tdp_wavs .w div{background:url(' + tidePlayerVar.wavImage + ') repeat-y 0 bottom;position:absolute;width:100%;bottom:0;left:0;display:block;height:0;box-shadow:inset 1px 1px 1px rgba(0,0,0,.7);}\
			'));
    };

    var loadScript = function(u, cb) {
        if (!u) return;
        var script = document.createElement('script');
        script.async = false;
        script.type = 'text/javascript';
        script.src = u;
        var head = document.head || document.getElementsByTagName('head')[0] || document.documentElement;
        head.insertBefore(script, head.firstChild);
        if (cb) {
            document.addEventListener ? script.addEventListener('load', cb, false) : script.onreadystatechange = function() {
                if (/loaded|complete/.test(script.readyState)) {
                    script.onreadystatechange = null;
                    cb();
                }
            }
        }
    };

    var encodeParam = function(a) {
        var b = new Array();
        for (var c in a) {
            b.push(c + "=" + encodeURIComponent(a[c]))
        }
        return b.join("&");
    };

    var showAdMask = function(obj) {
        var stt = _ad_info.ast == 2 ? ('剩余 <span>' + _ad_info.countdown + '</span> 秒') : '';
        var _alink = _ad_info.bv[_ad_info.bvp].link;
        obj.append(
                getDiv('_tdp_adt', '广告' + stt).append(
                    getDiv('_tdp_adc').text('×').click(function(e) {
                        _ad_info.bvp = _ad_info.bv.length;
                        switchShowAd();
                    })
                )
            )
            .append($('<a>').addClass('_tdp_adlm').attr('href', _alink).attr('target', '_blank'))
            .append($('<a>').addClass('_tdp_adl').attr('href', _ad_info.bv[_ad_info.bvp].link).attr('target', '_blank').text('查看详情'));
    };
    var showAdTime = function() {
        if (!_ad_info.isv) {
            _ad_info.countdown--;
        }
        if (_ad_info.countdown > 0) {
            getVD('_tdp_adt span').text(_ad_info.countdown);
        } else {
            getVD('_tdp_adt').hide();
        }
    };
    var showAdPause = function(show) {
        if (_ad_info) {
            try {
                getVD('_tdp_adp').toggle(show);
            } catch (e) {
                console.error(e.toString());
            };
            clearInterval(_ad_info.pdtimer);
            if (show) {
                _ad_info.ptcd = _ad_info.pv.duration;
                if (_ad_info.ptcd > 0) {
                    try {
                        getVD('_tdp_adpt span').text(_ad_info.ptcd);
                    } catch (e) {

                    }
                    _ad_info.pdtimer = setInterval(showPAdTimer, 1000);
                }
            }
        }
    };
    var showPAdTimer = function() {
        _ad_info.ptcd--;
        if (_ad_info.ptcd < 0) {
            showAdPause(false);
        } else {
            try {
                getVD('_tdp_adpt span').text(_ad_info.ptcd);
            } catch (e) {

            }
            if ((_ad_info.pv.duration - _ad_info.ptcd) > tidePlayerVar.showAdClose && _ad_info.ulg) {
                getVD('_tdp_adpt ._tdp_adc').show();
                getVD('_tdp_adpt').css('padding-right', '0');
            }
        }
    };
    var showAdTimer = function() {
        if ((_ad_info.total - _ad_info.countdown) > tidePlayerVar.showAdClose && _ad_info.ulg) {
            getVD('_tdp_adt ._tdp_adc').show();
            getVD('_tdp_adt').css('padding-right', '0');
        }
        if (_ad_info.isv) {
            _ad_info.bvt = _ad_info.isvt - _ad_info.countdown;
        } else {
            _ad_info.bvt++;
        }
        //trace("showAdTimer>"+_ad_info.bvt+">"+_ad_info.bv[_ad_info.bvp].duration+">"+_ad_info.countdown);
        if (_ad_info.bvt >= _ad_info.bv[_ad_info.bvp].duration || _ad_info.vend) {
            _ad_info.bvp++;
            switchShowAd();
        } else {
            showAdTime();
        }
    };
    var switchShowAd = function() {
        try {
            getVD('_tdp_box ._tdp_adi').remove();
        } catch (e) {
            console.error(e.toString());
        };
        if (_ad_info.bvp >= _ad_info.bv.length) {
            clearInterval(_ad_info.cdtimer);
            getVD('_tdp_adt').remove();
            getVD('_tdp_adlm').remove()
            getVD('_tdp_adl').remove();
            _tidev.pad = false;
            _ad_info.show = false;
            playTdH5(true);
            return;
        }
        _ad_info.bvt = 1;
        _ad_info.vend = false;
        var adm = _ad_info.bv[_ad_info.bvp].material;
        if (chechIsImage(adm)) {
            _ad_info.isv = false;
            getVD('_tdp_box').append(getDiv('_tdp_adi').css('background-image', 'url(' + adm + ')'));
            _tidev.v.poster = adm;
            _tidev.v.src = '';
            getVD('_tdp_buffer').hide();
        } else {
            _ad_info.isv = true;
            _ad_info.isvt = _ad_info.countdown;
            _tidev.v.poster = '';
            _tidev.v.src = adm;
            _tidev.v.currentTime = 0;
            _tidev.v.play();
        }
        if (__alog != 1) {
            loadScript(_ad_info.bv[_ad_info.bvp].logs);
        }
        if (_ad_info.show) {
            var _alink = _ad_info.bv[_ad_info.bvp].link;
            getVD('_tdp_adlm').attr('href', _alink);
            getVD('_tdp_adl').attr('href', _alink);
        }
        showAdTime();
    };
    var tdplayerClick = function(e) {
        if (__chrome_muted) {
            __chrome_muted = false;
            if (_tidev.oldvol > 0 && _tidev.vol <= 0) {
                getVD('_tdp_vol').click();
            }
        }
        window.haveClick = true;
        if (_tidev && _tidev.v) {
            _tidev.v.muted = false;
            if (__swf) {
                audioProcessor(true);
            }
        }
    }
    var initTdH5 = function(ph, vds, w, h, isHLS) {
        if (!window.__tdDrag) {
            window.__tdDrag = {
                drag: false,
                ix: 0,
                mx: 0,
                hand: null,
                call: null,
                vol: false,
                volhand: null,
                volcall: null
            }
        };
        $(document).on('mousemove touchmove', function(e) {
            if (window.__tdDrag.drag) {
                var e = e || window.event;
                var oX = (e.clientX || e.touches[0].clientX) - window.__tdDrag.ix + 10;
                if (oX < 0) {
                    oX = 0;
                }
                if (oX > window.__tdDrag.mx) {
                    oX = window.__tdDrag.mx;
                }
                window.__tdDrag.hand.css({
                    "left": oX + "px"
                });
                return false;
            }
            if (window.__tdDrag.vol) {
                var e = e || window.event;
                var oY = e.clientY - window.__tdDrag.ix;
                if (oY < 10) {
                    oY = 10;
                }
                if (oY > window.__tdDrag.mx) {
                    oY = window.__tdDrag.mx;
                }
                window.__tdDrag.volhand.css({
                    "top": oY + "px"
                });
                window.__tdDrag.volcall();
                return false;
            }
        });
        $(document).on('mousedown', tdplayerClick);
        $(document).on('mouseup touchend', function(e) {
            if (window.__tdDrag.drag) {
                window.__tdDrag.call();
                window.__tdDrag.drag = false;
                if (window.__tdDrag.hand) {
                    try {
                        window.__tdDrag.hand[0].releaseCapture();
                    } catch (e) {
                        //console.error(e.toString());
                    }
                    window.__tdDrag.hand = null;
                }
                e.cancelBubble = true;
            }
            if (window.__tdDrag.vol) {
                window.__tdDrag.volcall(true);
                window.__tdDrag.vol = false;
                if (window.__tdDrag.volhand) {
                    try {
                        window.__tdDrag.volhand[0].releaseCapture();
                    } catch (e) {
                        //console.error(e.toString());
                    }
                    window.__tdDrag.volhand = null;
                }
                e.cancelBubble = true;
            }
        });
        $(document).keydown(function(e) {
                var e = e || window.event;
                if (e.target.tagName == 'BODY') {
                    if (e.keyCode == 32) {
                        togglePlayPause();
                        if (e.preventDefault) {
                            e.preventDefault();
                        } else {
                            window.event.returnValue = false;
                        }
                    }
                    if (e.keyCode == 38) {

                    }
                    if (e.keyCode == 40) {

                    }
                }
            })
            /*
            $(document).on('visibilitychange', function() {
            	if (document.visibilityState == 'hidden') {
            		if (!_tidev.pad) {
            			_tidev.v.pause();
            			showCtrlBar();
            			showAdPause(true);
            		}
            	}
            });
            */
            //
        _tidev = {
            box: null,
            hls: __not_access_mse ? false : isHLS,
            live: false, //是否直播
            defname: {
                v: '流畅',
                v_sd: '标清',
                v_hd: '高清'
            },
            def: {}, //含有码率
            nplay: null, //当前码率
            v: null, //video对象
            vh: null, //HLS对象
            cTimer: 0, //控制栏
            sTimer: 0, //速度栏
            rTimer: 0, //码率列表
            vol: __vol, //音量栏(记录音量)
            oldvol: __vol, //
            pad: false, //是否正在播广告
            fp: true, //是否首次播放
            start: false //正片是否开始播放
        };
        var _th_pvad;
        var _th_pvada;
        if (_ad_info) {
            _tidev.pad = true;
            if (_ad_info.pv && _ad_info.pv.material) {
                _th_pvada = $('<a>').attr('href', _ad_info.pv.link).attr('target', '_blank');
                _th_pvad = getDiv('_tdp_adp', getDiv('box', _th_pvada).append(
                    getDiv('_tdp_adpt', '广告' + (_ad_info.ast == 2 ? (_ad_info.pv.duration > 0 ? ('剩余 <span></span> 秒') : '') : '')).append(
                        getDiv('_tdp_adc').text('×').click(function(e) {
                            showAdPause(false);
                        })
                    )
                ));
                var _th_pimg = new Image();
                _th_pimg.onload = function() {
                    _th_pvad.css('width', this.width + 'px').css('height', this.height + 'px').css('margin-left', this.width / 2 * -1 + 'px').css('margin-top', this.height / 2 * -1 + 'px');
                    _th_pvada.append(this);
                };
                _th_pimg.onerror = function() {
                    _th_pvad = null;
                };
                _th_pimg.src = _ad_info.pv.material;
                if (__alog != 1) {
                    loadScript(_ad_info.pv.logs);
                }
            }
        }
        //
        var mutedStr = '';
        if (window.haveClick) {

        } else {
            if (__chrome_muted) {
                _tidev.vol = 0;
                mutedStr = 'muted';
            }
        }
        var vol_btn = getDiv('_tdp_vol').hover(
            function(e) {
                getVD('_tdp_volctrl').show();
            },
            function(e) {
                getVD('_tdp_volctrl').hide();
            }
        ).click(function(e) {
            if (_tidev.vol <= 0) {
                _tidev.vol = _tidev.oldvol || 100;
                setVOL();
            } else {
                _tidev.oldvol = _tidev.vol;
                _tidev.vol = 0;
                setVOL();
            }
        }).addClass(_tidev.vol <= 0 ? 'muted' : '');
        var vol_ctrl = getDiv('_tdp_volctrl', getDiv('block', getDiv('bg')).append(
            getDiv('hand').mousedown(function(e) {
                window.__tdDrag.vol = true;
                window.__tdDrag.volhand = $(this);
                window.__tdDrag.ix = e.clientY - this.offsetTop;
                window.__tdDrag.mx = 60;
                window.__tdDrag.volcall = updateVOL;
                this.setCapture && this.setCapture();
                return false;
            }).css('top', ((1 - _tidev.vol / 100) * 50 + 10) + 'px')
        )).hover(
            function(e) {
                $(this).show();
            },
            function(e) {
                $(this).hide();
            }
        ).mousedown(function(e) {
            var t = e.offsetY;
            if (t < 10) {
                t = 10;
            }
            if (t > 60) {
                t = 60;
            }
            $(this).find('.hand').css('top', t + 'px');
            updateVOL();
        });
        var vol_right_x = __isMob ? 35 : 70;
        //
        var _th_ig = getDiv('_tdp_ing', $('<span>')).append($('<bdo>').click(function(e) {
            var per = (e.pageX - $(this).offset().left) / $(this).width();
            _tidev.v.currentTime = _tidev.v.duration * per;
        })).append($('<abbr>').on('mousedown touchstart', function(e) {
            if (!_tidev.fp) {
                var e = e || window.event;
                window.__tdDrag.drag = true;
                window.__tdDrag.hand = $(this);
                window.__tdDrag.ix = (e.clientX || e.touches[0].clientX) - this.offsetLeft;
                window.__tdDrag.mx = getVD('_tdp_ing bdo').width();
                window.__tdDrag.call = updatePT;
                this.setCapture && this.setCapture();
            }
            return false;
        }));
        var _th_tt = getDiv('_tdp_ttime');
        //
        var _th_rs = getDiv('_tdp_speed', __iss.toFixed(1) + 'x').click(function(e) {
            clearTimeout(_tidev.sTimer);
            var _rl = getVD('_tdp_speedlist');
            if (_rl.is(':hidden')) {
                _rl.show();
                _tidev.sTimer = setTimeout(function() {
                    clearTimeout(_tidev.sTimer);
                    _rl.hide();
                }, 2000);
            } else {
                _rl.hide();
            }
        });
        var _th_rsl = getDiv('_tdp_speedlist');
        ['3.0', '2.0', '1.5', '1.25', '1.0', '0.5', '0.1'].forEach(function(va) {
            _th_rsl.append($('<span>').text(va + 'x').data('v', va).click(function(e) {
                changeSpeed($(this).data('v'));
            }));
        });
        if (!__sss) {
            _th_rs.hide();
        }
        //
        var _th_rl = getDiv('_tdp_ratelist');
        var _th_vlen = 0;
        //////////////////////////vds[1].url = 'bbb.mp4'; //TEST
        for (var i = 0; i < vds.length; i++) {
            var _vt = vds[i];
            if (_vt.url) {
                _tidev.def[_vt.type] = _vt.url;
                _tidev.nplay = _vt.type;
                _th_rl.append($('<span>').attr('name', _vt.type).text(_tidev.defname[_vt.type]).click(function(e) {
                    changeRate($(this).attr('name'));
                }));
                _th_vlen++;
            }
        }
        _th_rl.find("span[name='" + _tidev.nplay + "']").addClass('n');
        var _th_rlt = getDiv('_tdp_rate', _tidev.defname[_tidev.nplay]).click(function(e) {
            clearTimeout(_tidev.rTimer);
            var _rl = getVD('_tdp_ratelist');
            if (_rl.is(':hidden')) {
                _rl.show();
                _tidev.rTimer = setTimeout(function() {
                    clearTimeout(_tidev.rTimer);
                    _rl.hide();
                }, 2000);
            } else {
                _rl.hide();
            }
        });

        _th_rlt.css('right', vol_right_x + 'px');
        _th_rl.css('right', (vol_right_x - 5) + 'px');
        vol_right_x += 40;

        if (_th_vlen < 2) {
            _th_rlt.hide();
            vol_right_x -= 40;
        }

        _th_rs.css('right', vol_right_x + 'px');
        _th_rsl.css('right', (vol_right_x - 5) + 'px');

        if (__sss) {
            vol_right_x += (40 + 10);
        }
        //
        _th_ig.css('right', vol_right_x + 'px');
        _th_tt.css('right', vol_right_x + 'px');
        //
        var big_playbtn = getDiv('_tdp_bigbtn').click(function(e) {
            clearTimeout(_npinfo.t);
            if (_tidev.fp) {
                playTdH5(true);
            } else {
                _tidev.v.play();
                if (_tidev.pad) return;
                showCtrlBar();
                showAdPause(false);
            }
        }).toggle(!__ap);
        //
        var _th_p = getDiv('_tdp_box').css('width', w).css('height', h).on('selectstart', function(e) { return false; }).on('contextmenu', function(e) { return false; });
        _th_p.append(getDiv('_tdp_poster').css('background-image', 'url(' + ph + ')').toggle(!__ap)).
        append(getDiv('_tdp_vbox', '<video id="hv_' + __id + '" class="wh100"' + (__ap ? 'autoplay ' : '') + ' webkit-playsinline playsinline preload="auto" ' + mutedStr + ' x5-playsinline="" x5-video-orientation="landscape" x-webkit-airplay="true" x5-video-player-fullscreen="true" x5-video-ignore-metadata="true" x5-video-player-type="h5"></video>').mousedown(function(e) {
            if (e.which == 1) {
                togglePlayPause();
            }
        }).dblclick(fullExit)).
        append(__sbp ? big_playbtn : '').
        append(getDiv('_tdp_buffer', $('<span>'))).
        mousemove(showCtrlBar);
        var _th_c = getDiv('_tdp_contrl', getDiv('_tdp_playbtn').click(function(e) {
            if (_tidev.fp) {
                playTdH5(true);
            } else {
                _tidev.v.play();
                showCtrlBar();
                showAdPause(false);
            }
        })).
        append(getDiv('_tdp_pausebtn').click(function(e) {
            _tidev.v.pause();
            showCtrlBar();
            showAdPause(true);
        })).
        append(_th_ig).
        append(getDiv('_tdp_ptime')).
        append(_th_tt).
        append(_th_rs).
        append(_th_rsl).
        append(_th_rlt).
        append(_th_rl).
        append(__isMob ? '' : vol_btn).
        append(__isMob ? '' : vol_ctrl).
        append(getDiv('_tdp_fullbtn').click(fullExit)).
        mousedown(showCtrlBar);

        if (__swf) {
            leftWavHand = getDiv('left_h');
            rightWavHand = getDiv('right_h');
            _th_p.append(
                getDiv('_tdp_wavs').append(
                    getDiv('w').append(leftWavHand),
                    getDiv('w').append(rightWavHand)
                )
            );
        }
        _th_p.append(_th_c);
        if (_th_pvad) {
            _th_p.append(_th_pvad);
        }
        $('#' + __id).append(_th_p);
        _tidev.v = $('#hv_' + __id).on('loadedmetadata', function() {
            _tidev.dur = this.duration;
            if (_tidev.dur.toString() == 'Infinity') {
                _tidev.live = true;
                getVD('_tdp_ing').hide();
                getVD('_tdp_ttime').hide();
                getVD('_tdp_ptime').css('bottom', '13px');
            } else {
                getVD('_tdp_ttime').text(formatTime(this.duration));
            }
        }).on('timeupdate', function() {
            if (_tidev.pad) {
                if (_ad_info.isv) {
                    _ad_info.countdown = Math.ceil(_ad_info.isvt - this.currentTime);
                    showAdTime();
                }
            } else {
                getVD('_tdp_ptime').text(formatTime(this.currentTime));
                if (!window.__tdDrag.drag) {
                    var lw = (this.currentTime / this.duration * 100) + '%';
                    getVD('_tdp_ing abbr').css('left', lw);
                    if (_tidev.hls) {
                        getVD('_tdp_ing span').css('width', lw);
                    }
                }
            }
        }).on('progress', function() {
            if (this.paused) return;
            if (!_tidev.hls) {
                try {
                    var range = 0;
                    var bf = this.buffered;
                    var time = this.currentTime;
                    while (!(bf.start(range) <= time && time <= bf.end(range))) {
                        range += 1;
                    }
                    var loadStartPercentage = bf.start(range) / this.duration;
                    var loadEndPercentage = bf.end(range) / this.duration;
                    getVD('_tdp_ing span').css('width', (loadEndPercentage - loadStartPercentage) * 100 + '%');
                } catch (e) {
                    console.error(e.toString());
                }
            }
        }).on('ended', function() {
            if (_tidev.pad) {
                _ad_info.vend = true;
            } else {
                this.currentTime = 0;
                this.pause();
                showCtrlBar();
                showAdPause(false);
                _tidev.fp = true;
                _tidev.start = false;
                playEnd();
            }
        }).on('waiting', function() {
            getVD('_tdp_buffer').show();
        }).on('playing', function() {
            getVD('_tdp_buffer').hide();
            showCtrlBar();
            if (!_tidev.pad && !_tidev.start) {
                _tidev.start = true;
                if (__uek) {
                    __uek(1, _vinfo);
                }
                getRecommand();
            }
        }).on('play', function() {
            getVD('_tdp_playbtn').hide();
            getVD('_tdp_pausebtn').show();
            getVD('_tdp_bigbtn').hide();
        }).on('pause', function() {
            getVD('_tdp_bigbtn').show();
            if (_tidev.pad) return;
            getVD('_tdp_playbtn').show();
            getVD('_tdp_pausebtn').hide();
        }).on('error', function(err) {

        }).get(0);
        _tidev.v.volume = _tidev.vol / 100;
        _tidev.box = _th_p.get(0);
        if (__ap) {
            playTdH5();
        }
    };
    var togglePlayPause = function() {
        if (_tidev && _tidev.v) {
            if (_tidev.pad) return;
            if (_tidev.v.paused) {
                getVD('_tdp_playbtn').click();
            } else {
                getVD('_tdp_pausebtn').click();
            }
        }
    }
    var playTdH5 = function(startPlay) {
        if (__upk && !__upk()) {
            return;
        }
        getVD('_tdp_poster').hide();
        _tidev.fp = false;
        if (_tidev.pad && _ad_info.bv.length > 0) {
            _ad_info.countdown = _ad_info.total;
            _ad_info.bvp = 0;
            _ad_info.show = true;
            showAdMask(getVD('_tdp_box'));
            switchShowAd();
            clearInterval(_ad_info.cdtimer);
            _ad_info.cdtimer = setInterval(showAdTimer, 1000);
        } else {
            var _fpurl = _tidev.def[_tidev.nplay];
            var notaccess = is_mf.indexOf(getSuffix(_fpurl)) == -1;
            if (_fpurl.indexOf(m3u8_suf) != -1) {
                notaccess = false;
                _fpurl = _fpurl.replace(m3u8_suf, 'http://');
            }
            if (_fpurl.indexOf(m3u8s_suf) != -1) {
                notaccess = false;
                _fpurl = _fpurl.replace(m3u8s_suf, 'https://');
            }
            if (notaccess) {
                noAvTip(_fpurl);
                return;
            } else {
                _tidev.pad = false;
                if (_tidev.hls) {
                    _tidev.vh = new Hls();
                    _tidev.vh.attachMedia(_tidev.v);
                    _tidev.vh.loadSource(_fpurl);
                    hlsEventHand();
                } else {
                    _tidev.v.src = _fpurl;
                }
                if (startPlay) {
                    var pps = _tidev.v.play();
                }
                if (__iss != 1) {
                    _tidev.v.playbackRate = __iss;
                }
                if (__ap && window.haveClick) {
                    tdplayerClick();
                }
            }
        }
        showCtrlBar();
    };

    var hlsEventHand = function() {
        _tidev.vh.on(Hls.Events.LEVEL_LOADED, function(e, data) {
            if (data.details) {
                _tidev.live = data.details.live;
                if (_tidev.live) {
                    getVD('_tdp_ing').hide();
                    getVD('_tdp_ttime').hide();
                    getVD('_tdp_ptime').css('bottom', '13px');
                } else {
                    getVD('_tdp_ing').show();
                    getVD('_tdp_ttime').show();
                    getVD('_tdp_ptime').css('bottom', '8px');
                }
            }
        });
        _tidev.vh.on(Hls.Events.ERROR, function(event, data) {
            console.log(data);
            if (data.fatal) {
                switch (data.type) {
                    case Hls.ErrorTypes.NETWORK_ERROR:
                        // try to recover network error
                        //console.log("fatal network error encountered, try to recover");
                        _tidev.vh.startLoad();
                        break;
                    case Hls.ErrorTypes.MEDIA_ERROR:
                        //console.log("fatal media error encountered, try to recover");
                        _tidev.vh.recoverMediaError();
                        break;
                    default:
                        // cannot recover
                        var __url = _tidev.vh.url;
                        var __ct = _tidev.v.currentTime;
                        try {
                            _tidev.vh.destroy();
                        } catch (e) {}
                        _tidev.vh = new Hls({
                            startPosition: _ct
                        });
                        hlsEventHand();
                        _tidev.vh.attachMedia(_tidev.v);
                        _tidev.vh.loadSource(__url);
                        break;
                }
            }
        });
    };

    var ap_run = false;
    var ap_ctx;
    var ap_processor;
    var ap_source;
    var audioProcessor = function(b) {
        if (ap_run == b) {
            return;
        }
        ap_run = b;
        if (b) {
            if (!ap_ctx) {
                try {
                    ap_ctx = new AudioContext();
                } catch (e) {
                    console.error(e);
                }
            }
            if (ap_ctx) {
                _tidev.v.crossOrigin = 'anonymous';
                ap_processor = ap_ctx.createScriptProcessor(256, 2, 2);
                ap_processor.onaudioprocess = function(evt) {
                    var ib = evt.inputBuffer;
                    var ld = ib.getChannelData(0);
                    var rd = ib.getChannelData(1);

                    var llen = ld.length;
                    var rlen = rd.length;
                    var i = 0;
                    var zoom = 5;
                    var ltot = rtot = 0;
                    while (i < llen) ltot += Math.abs(ld[i++]);
                    i = 0;
                    while (i < rlen) rtot += Math.abs(rd[i++]);

                    leftWavHand.css('height', (ltot / llen * zoom * 100) + '%');
                    rightWavHand.css('height', (rtot / rlen * zoom * 100) + '%');
                }
                if (!ap_source) {
                    try {
                        ap_source = ap_ctx.createMediaElementSource(_tidev.v);
                    } catch (e) {
                        console.error(e);
                    }
                    if (ap_source) {
                        ap_source.connect(ap_processor);
                        ap_source.connect(ap_ctx.destination);
                        ap_processor.connect(ap_ctx.destination);
                    }
                }
            }
        } else {
            if (ap_ctx) {
                try {
                    ap_ctx.close();
                } catch (e) {
                    console.error(e);
                }
            }
            ap_ctx = null;
            ap_processor = null;
            ap_source = null;
        }
    };
    var playEnd = function() {
        if (__uek) {
            __uek(0, _vinfo);
        }
        clearTimeout(_npinfo.t);
        if (_npinfo.u) {
            _npinfo.t = setTimeout(function() {
                window.location.href = _npinfo.u;
            }, _npinfo.w * 1000)
        }
    };
    var fullExit = function(e) {
        var dc = document;
        var pbox;
        if (__isMob) {
            pbox = _tidev.v;
            if (pbox.webkitEnterFullscreen) {
                pbox.webkitEnterFullscreen();
            };
        } else {
            pbox = $('#' + __id).get(0);
            var isf = dc.fullscreen || dc.webkitIsFullScreen || dc.mozFullScreen || false;
            if (isf) {
                if (dc.exitFullscreen) {
                    dc.exitFullscreen();
                } else if (dc.mozCancelFullScreen) {
                    dc.mozCancelFullScreen();
                } else if (dc.webkitCancelFullScreen) {
                    dc.webkitCancelFullScreen();
                }
            } else {
                if (pbox.requestFullscreen) {
                    pbox.requestFullscreen();
                } else if (pbox.mozRequestFullScreen) {
                    pbox.mozRequestFullScreen();
                } else if (pbox.webkitRequestFullScreen) {
                    pbox.webkitRequestFullScreen();
                }
            }
        }
    };
    var getDiv = function(cn, ht) {
        var _div = $('<div>').addClass(cn);
        if (ht) {
            _div.append(ht);
        }
        return _div;
    };
    var getVD = function(d) {
        return $('#' + __id + ' .' + d);
    };
    var updatePT = function() {
        var per = parseInt(getVD('_tdp_ing abbr').css('left')) / getVD('_tdp_ing bdo').width();
        _tidev.v.currentTime = _tidev.v.duration * per;
        showCtrlBar();
    };
    var updateVOL = function(isend) {
        var per = (parseInt(getVD('_tdp_volctrl .hand').css('top')) - 10) / 50;
        _tidev.v.volume = 1 - per;
        _tidev.vol = (1 - per) * 100;
        if (isend) {
            getVD('_tdp_volctrl').hide();
        }
        getVD('_tdp_vol').removeClass('muted').addClass(_tidev.vol <= 0 ? 'muted' : '');
    };
    var setVOL = function() {
        _tidev.v.volume = _tidev.vol / 100;
        getVD('_tdp_volctrl .hand').css('top', ((1 - _tidev.vol / 100) * 50 + 10) + 'px');
        getVD('_tdp_vol').removeClass('muted').addClass(_tidev.vol <= 0 ? 'muted' : '');
    };
    var showCtrlBar = function() {
        if (_tidev.pad) {
            getVD('_tdp_contrl').hide();
            clearTimeout(_tidev.cTimer);
            return;
        }
        getVD('_tdp_contrl').show();
        clearTimeout(_tidev.cTimer);
        if (_tidev.v.paused) return;
        _tidev.cTimer = setTimeout(function() {
            if (!window.__tdDrag.drag) {
                getVD('_tdp_contrl').hide();
            }
        }, 3000);
    };
    var changeSpeed = function(sn) {
        getVD('_tdp_speed').text(sn + 'x');
        _tidev.v.playbackRate = Number(sn);
        getVD('_tdp_speedlist').hide();
        clearTimeout(_tidev.sTimer);
    };
    var changeRate = function(rn) {
        if (_tidev.nplay == rn) {
            getVD('_tdp_ratelist').hide();
        } else {
            var _ct = _tidev.v.currentTime;
            _tidev.nplay = rn;
            if (_tidev.hls) {
                try {
                    _tidev.vh.destroy();
                } catch (e) {}
                _tidev.vh = new Hls({
                    startPosition: _ct
                });
                hlsEventHand();
                _tidev.vh.attachMedia(_tidev.v);
                _tidev.vh.loadSource(_tidev.def[rn]);
            } else {
                _tidev.v.src = _tidev.def[rn];
                _tidev.v.currentTime = _ct;
            }
            _tidev.v.play();
            getVD('_tdp_rate').text(_tidev.defname[rn]);
            getVD('_tdp_ratelist span').removeClass();
            getVD('_tdp_ratelist').hide().find("span[name='" + rn + "']").addClass('n');
            clearTimeout(_tidev.rTimer);
        }
    };
    var formatTime = function(n) {
        var h = Math.floor(n / 3600);
        var m = Math.floor((n % 3600) / 60);
        var s = Math.floor(n % 60);
        return (h > 0 ? ((h < 10 ? ('0' + h) : h) + ':') : '') + (m < 10 ? ('0' + m) : m) + ':' + (s < 10 ? ('0' + s) : s);
    };
    var chechIsImage = function(url) {
        url = url.toLowerCase();
        return url.indexOf('.jpg') != -1 || url.indexOf('.gif') != -1 || url.indexOf('.png') != -1;
    };
    var getAdInfo = function() {
        if (__ch) {
            $.ajax({
                url: tidePlayerVar.adPortal.replace('{{CHANNEL}}', __ch),
                dataType: 'json',
                success: function(data) {
                    var llg;
                    if (data.beforeAD) {
                        var ba = data.beforeAD[0];
                        if (ba && ba.material.toLowerCase().indexOf('.swf') == -1) {
                            _ad_info.bv.push(ba);
                        }
                        llg = ba.logs;
                    }
                    if (data.pauseAD) {
                        var pa = data.pauseAD;
                        if (pa.material.toLowerCase().indexOf('.swf') == -1) {
                            _ad_info.pv = pa;
                        }
                        llg = pa.logs;
                    }
                    if (__alog == 1 && llg) {
                        loadScript(llg);
                    }
                    getAdInfo();
                },
                timeout: 3000,
                error: function(jqXHR, textStatus, errorThrown) {
                    /* test
                    var data={
                    	beforeAD:[
                    		{
                    			material:"aaa.mp4",
                    			link:"",
                    			duration:4,
                    			logs:""
                    		}
                    	]
                    };
                    if (data.beforeAD) {
                    	var ba = data.beforeAD[0];
                    	if (ba && ba.material.toLowerCase().indexOf('.swf') == -1) {
                    		console.log(ba.material);
                    		_ad_info.bv.push(ba);
                    	}
                    }
                    */
                    getAdInfo();
                }
            }).done(function() {
                //console.error('ad done');
            });
            __ch = null;
        } else {
            for (var i = 0; i < _ad_info.bv.length; i++) {
                var adt = Number(_ad_info.bv[i].duration);
                if (isNaN(adt) || adt <= 0) {
                    _ad_info.bv.splice(i, 1);
                    i--;
                } else {
                    _ad_info.total += adt;
                }
            }
            getVideoInfo();
        }
    };
    var getVideoInfo = function() {
        if (__video) {
            __video = clearQURL(__video);
            var hzv = getSuffix(__video);
            if (is_mf.indexOf(hzv) == -1) {
                noAvTip(hzv);
            } else {
                var hls = false;
                if (checkIsHLS(__video)) {
                    hls = true;
                }
                try {
                    $('#tdpt_' + __id).remove();
                } catch (e) {
                    console.error(e.toString());
                };
                initTdH5(initobj.cover || '', [{ type: "v_sd", url: __video }], __ww, __hh, hls);
            }
        } else {
            if (typeof(__json) == 'object') {
                videoInfoOver(__json);
            } else {
                if (initobj.callback) {
                    getVIJsonp();
                } else {
                    $.getJSON(clearQURL(__json), videoInfoOver).fail(getVIJsonp);
                }
            }
        }
    };
    var getVIJsonp = function() {
        $.ajax({
            url: clearQURL(__json),
            dataType: 'jsonp',
            jsonp: (initobj.callback || "funcname"),
            success: videoInfoOver,
            error: function() {
                noAvTip();
            }
        });
    };
    var videoInfoOver = function(data) {
        _vinfo = {
            id: data.id,
            title: data.title,
            duration: data.duration
        };
        var hasHLS = false;
        data.videos.forEach(function(el, ix) {
            if (checkIsHLS(el.url)) {
                hasHLS = true;
            }
        });
        try {
            $('#tdpt_' + __id).remove();
        } catch (e) {
            console.error(e.toString());
        };
        initTdH5(initobj.cover || data.photo, data.videos, __ww, __hh, hasHLS);
        var _w = Number(data.wait);
        if (!isNaN(_w) && _w > 0) {
            _npinfo.w = _w;
        }
    }
    var getSuffix = function(url) {
        var urlw = url.split("?")[0];
        var urld = urlw.split(".");
        return "." + urld.pop().toLowerCase();
    };
    var checkIsHLS = function(url) {
        if (url) {
            if (url.indexOf(m3u8_suf) != -1) {
                return true;
            }
            if (url.indexOf(m3u8s_suf) != -1) {
                return true;
            }
            return is_hls.indexOf(getSuffix(url)) != -1;
        }
        return false;
    };
    var noAvTip = function(hz) {
        try {
            $('#' + __id).html(getDiv("_tdp_tip", hz ? ("当前内容(" + hz + ")不支持移动设备播放！") : "视频错误！"));
        } catch (e) {
            console.error(e.toString());
        }
    };
    var checkJQ = function() {
        if (window.jQuery) {
            if (__ie) {
                initFlash();
            } else {
                checkHls();
            }
        } else {
            loadScript(tidePlayerVar.jQurl, function() {
                checkJQ();
            });
        };
    };
    var checkHls = function() {
        if (window.Hls) {
            initH5();
        } else {
            loadScript(tidePlayerVar.HLSurl, function() {
                checkHls();
            });
        };
    };
    var initFlash = function() {
        var varslist = [];
        for (var key in initobj) {
            varslist.push(key + "=" + encodeURIComponent(initobj[key]));
        }
        var flavars = varslist.join("&");
        var swfid = __id + '_flash';
        $('#' + __id).append(
            '<object id="' + swfid + '" width="' + __ww + '" height="' + __hh + '" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000">' +
            '<param name="movie" value="' + tidePlayerVar.flashPath + '" /><param name="FlashVars" value="' + flavars + '" /><param name="wmode" value="opaque" /><param name="allowScriptAccess" value="always" /><param name="allowFullScreen" value="true" />' +
            '<embed name="' + swfid + '" width="' + __ww + '" height="' + __hh + '" src="' +
            tidePlayerVar.flashPath + '" wmode="opaque" allowFullScreen="true" allowScriptAccess="always" FlashVars="' + flavars +
            '" type="application/x-shockwave-flash"></embed></object>'
        );
    };
    var initH5 = function() {
        writeStyle();
        if (__ch) {
            _ad_info = {
                bv: [], //片头
                bvp: 0, //片头播放位置
                bvt: 0, //片头每段时间
                pv: {}, //暂停
                ptcd: 0, //暂停倒计时
                pdtimer: 0, //暂停广告计时器
                total: 0, //总时长
                countdown: 0, //倒计时
                cdtimer: 0, //前广告计时器
                show: false, //是否已经显示
                isv: false, //是否是视频
                isvt: 0, //如果是视频，初始的计时时间
                vend: false, //视频播放是否结束
                ast: __ast
            };
            if (__uck) {
                _ad_info.ulg = __uck();
            } else {
                _ad_info.ulg = false;
            }
            getAdInfo();
        } else {
            getVideoInfo();
        }
    };
    var getRecommand = function() {
        if (_npinfo.l) {
            return;
        }
        _npinfo.l = true;
        if (__rec) {
            $.ajax({
                url: clearQURL(__rec),
                dataType: 'jsonp',
                success: function(data) {
                    try {
                        _npinfo.u = data[0].page;
                    } catch (e) {
                        console.error(e.toString());
                    }
                },
                timeout: 10000,
                error: function() {}
            });
        }
    }
    var clearQURL = function(url) {
        if (url.indexOf('.') == -1) {
            return decode64(url);
        }
        return url;
    }
    var decode64 = function(a) {
            if (a.indexOf(".") != -1) return a;
            var b = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
                25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41,
                42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1
            ];
            var c, c2, c3, c4, i, len, out;
            len = a.length;
            i = 0;
            out = "";
            while (i < len) {
                do {
                    c = b[a.charCodeAt(i++) & 0xff];
                }
                while (i < len && c == -1);
                if (c == -1) break;
                do {
                    c2 = b[a.charCodeAt(i++) & 0xff];
                }
                while (i < len && c2 == -1);
                if (c2 == -1) break;
                out += String.fromCharCode((c << 2) | ((c2 & 0x30) >> 4));
                do {
                    c3 = a.charCodeAt(i++) & 0xff;
                    if (c3 == 61) return out;
                    c3 = b[c3]
                }
                while (i < len && c3 == -1);
                if (c3 == -1) break;
                out += String.fromCharCode(((c2 & 0XF) << 4) | ((c3 & 0x3C) >> 2));
                do {
                    c4 = a.charCodeAt(i++) & 0xff;
                    if (c4 == 61) return out;
                    c4 = b[c4]
                }
                while (i < len && c4 == -1);
                if (c4 == -1) break;
                out += String.fromCharCode(((c3 & 0x03) << 6) | c4)
            }
            return out
        }
        //
    var m3u8_suf = "m3u8://";
    var m3u8s_suf = "m3u8s://";
    var is_hls = ".m3u8";
    var is_mf = ".mp4.mp3.m4a.m4v.mov" + is_hls;
    //
    var __b_nav = window.navigator.appVersion;
    var __chrome = __b_nav.match(/Chrome\/\d{2}/);
    var chrome66 = false;
    if (__chrome && __chrome.length > 0) {
        chrome66 = Number(__chrome[0].split('/')[1]) >= 66;
    }
    var mmts = window.navigator.mimeTypes;
    var is360 = false;
    for (var mk in mmts) {
        if (mmts[mk]["type"] == "application/vnd.chromium.remoting-viewer") {
            is360 = true;
            break;
        }
    }
    var __chrome_muted = false;
    if (!is360 && chrome66) {
        __chrome_muted = true;
    }
    var __ie = __b_nav.indexOf("MSIE") >= 1;
    var __isMob = __b_nav.indexOf('Mobile') > 0;
    var __isIOS = __b_nav.indexOf('iPhone') > 0 || __b_nav.indexOf('iPad') > 0;
    var __isWechat = __b_nav.indexOf('MicroMessenger') > 0;
    var __isQQ = __b_nav.indexOf('QQ') > 0;
    if (__isQQ) {
        __chrome_muted = false;
    }
    var __isWIFI = __b_nav.indexOf('NetType/WIFI') > 0;
    //
    var __video = initobj.video;
    var __json = initobj.json;
    if (!__json && !__video) {
        alert('没有可用内容！');
        return;
    }
    var __w = initobj.width || '100%';
    var __h = initobj.height || '100%';
    var __id = initobj.id || ('tdplayer_' + Math.ceil(Math.random() * 1e10));
    var __ap = initobj.autoplay;
    if (__ap == undefined) {
        __ap = true;
    }
    if (__isMob) {
        if (__isQQ && __isWIFI) {} else {
            __ap = false;
        }
    }
    var __nomse = initobj.nomse || false;
    var __not_access_mse = false;
    if (__isIOS) {
        __not_access_mse = true;
    }
    if (__nomse && __isMob) {
        __not_access_mse = true;
    }
    var __rec = initobj.recommand;
    var __ch = initobj.channel;
    var __noad = initobj.noad || false; //默认是否显示广告
    if (__noad) {
        __ch = null;
    }
    var __alog = 1; //1-加载曝光 !1-播出曝光
    var __ast = initobj.adshowtype || 2; //广告显示样式，1-只显示广告字样 2-同时显示倒计时
    //
    var __uck = initobj.userCall || null; //播放前校验接口函数，如果返回true，将可以显示跳过广告，默认财新检测
    var __upk = initobj.playCall || null; //播放判断函数，当返回true，表示可以播放，否则不进行下一步，默认无
    var __uek = initobj.eventCall || null; //播放器播出回调JS函数名称，传1为开始播放，传2为结束播放
    var __umc = initobj.minimize;
    var __swf = initobj.waveform || false;
    var __sss = initobj.speed || false; //set speed show
    var __iss = initobj.playRate || 1; //初始播出速度
    var __sbp = initobj.bigPlay; //是否展示大播放按钮
    if (__sbp == undefined) {
        __sbp = true;
    }
    var __vol = initobj.vol;
    if (__vol == undefined) {
        __vol = 100;
    }
    var leftWavHand, rightWavHand;
    //
    var _tidev;
    var _ad_info;
    var _npinfo = {
        l: false, //是否已经读取接口
        w: 0, //跳转等待时间，秒
        u: '', //地址
        t: 0 //timer对象
    };
    var _vinfo;
    /*
    onerror=function(msg,url,l){
    	console.error(msg,url,l);
    	return true;
    }*/
    //
    var __ww = __w.toString().indexOf('%') == -1 ? (__w + 'px') : __w;
    var __hh = __h.toString().indexOf('%') == -1 ? (__h + 'px') : __h;
    if (!initobj.divid) {
        document.write('<div style="width:' + __ww + ';height:' + __hh + '" id="' + __id + '"><div class="_tdp_tip" id="tdpt_' + __id + '"><div class="_tdp_buffer"></div></div></div>');
    } else {
        __id = initobj.divid;
    }
    checkJQ(true);
    //
    this.destroy = function() {
        try {
            _tidev.vh.destroy();
        } catch (e) {}
        _tidev = null;
    };
    this.play = function(time, playpause) {
        if (_tidev && _tidev.v) {
            if (_tidev.pad) return;

            if (time == undefined) {
                if (playpause == false) {
                    getVD('_tdp_pausebtn').click();
                } else {
                    getVD('_tdp_playbtn').click();
                }
                return;
            }

            if (time < 0 || time > _tidev.v.duration || _tidev.live) {
                return;
            }

            _tidev.v.currentTime = time;
            getVD('_tdp_ing abbr').css('left', (getVD('_tdp_ing bdo').width() * (time / _tidev.v.duration)) + 'px');

            if (playpause == false) {
                getVD('_tdp_pausebtn').click();
            } else if (playpause == true) {
                getVD('_tdp_playbtn').click();
            }
        }
    };
    this.currentTime = function() {
        return _tidev.v.currentTime;
    };
}

//http://tool.lu/js/

function trace() {
    var t = [];
    for (var i = 0; i < arguments.length; i++) {
        t.push(arguments[i]);
    }
    console.log((new Date()).toString() + "\tTIDE > " + t.join(','));
}