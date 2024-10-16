/*
                  Positioned(
                    bottom: 5,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0xffffffff))),
                              onPressed: (){
                                setState(() {
                                  toggleEreia = !toggleEreia;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(toggleEreia ? '🤴' : '👳‍',style: TextStyle(color: connected ? Colors.white : Colors.black,fontSize: 25),),
                              )
                          ),

                          !isFirstCam ? ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0xffffffff))),
                              onPressed: (){
                                _toggleTorch();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_isTorchOn ? '💡' : '🔦',style: TextStyle(color: connected ? Colors.white : Colors.black,fontSize: 25),),
                              )
                          ) : Container(),


                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Color(0xffffffff))),
                              onPressed: (){
                                _toggleCamera();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(isFirstCam ? '📱' : '📸',style: TextStyle(color: connected ? Colors.white : Colors.black,fontSize: 25),),
                              )
                          ),
                        ],
                      ),
                    ),
                  )

 */