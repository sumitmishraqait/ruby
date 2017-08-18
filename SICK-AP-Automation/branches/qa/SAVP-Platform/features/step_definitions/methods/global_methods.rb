require 'rubygems'
require 'socket'
require 'time'

# Do Not Remove This File
# This file contains assertion methods which are called "Globally" i.e. from multiple custom step definition files

# Method to check if an element is present or not
def is_element_present(element_id_type, element_id_value)
  begin
    if is_element_displayed(element_id_type, element_id_value)	 # selenium-cucumber api which essentially does the following #  WAIT.until{ $driver.find_element(:"#{element_id_type}" => "#{element_id_value}")
      return true
    end
    rescue Exception => e
      if e.message.include?("Unable to locate element") || e.message.include?("no such element") || e.message.include?("timed out after 30 seconds")	# Each browser throws a different error when an element is not found. Checking not found scenario for each Chrome, FF & IE11
        return false
      else
        puts e.message
        puts "Unexpected error or webdriver session timed out. Refer to captured exception text."
        raise TestCaseFailed, 'Unexpected error.'
        return false
      end
  end
end

# Method to push object(s) over TCP to a server for testing some UI/back-end features of server
def push_test_data_to_server(server_ip_address, server_port, string_type, test_system_name, push_count, delay)
  # establish TCP connection to server over specified port
  begin
   socket = TCPSocket.new(server_ip_address, server_port)
  rescue => e
   puts "TCP connection couldn't be eastablished due to error: #{e}"
  else
   puts "TCP connection established!"
  end

  if string_type == objectdata
    push_count.times do |oi|
      objdata = '<objectdata xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="Logging.xsd" version="1.0"><devicename>%{sys_name}</devicename><deviceid>32</deviceid><timestamp>%{time}</timestamp><incr>57823</incr><tokenid>%{sys_name}Test%{time}</tokenid><seqnb>7155</seqnb><general oi="%{obj_id}" on="1016" ox="7154" oc="0" is="51205" ie="52225" lftf="N" lfts="7" errornb="0" iostate="0C08"><timestamp>%{time}</timestamp><otl unit="inch"><value>40.74</value></otl><tt unit="ms"><value>373</value></tt><oga unit="inch"><value>69.52</value></oga><devicelist>FC300008</devicelist><udi udi2="206" udi3="1" udi4="10" udi5="0"/><uds uds1="&lt;rxstring&gt;02/10/2012;17:58:53;0206;00;4059;070;0015549346&lt;/rxstring&gt;&lt;rxoffset&gt;6.80&lt;/rxoffset&gt;&lt;rxfields&gt;&lt;ss&gt;00&lt;/ss&gt;&lt;sw&gt;0206&lt;/sw&gt;&lt;/rxfields&gt;&lt;condition&gt;OcsRx,OcsValid,OcsGood&lt;/condition&gt;&lt;txfields&gt;&lt;ss&gt;00&lt;/ss&gt;&lt;sw&gt;0206&lt;/sw&gt;&lt;/txfields&gt;" uds2="&lt;owe unit=&quot;lbs&quot;&gt;&lt;value&gt;20.60&lt;/value&gt;&lt;/owe&gt;" uds3="0" uds4="00" uds5="OK"/><usertag1 name="SE">SE0089SSA3CT1014718S0039.80010.80002.6IN  000000000020.6  000333]C10259612850147114161000158]L0272PDF]C1023S-BB065D1SLOF-WOC000</usertag1><usertag2 name="SI">SISSA3CT10147189612850147114161000158                            0039.80010.80002.6IN000000000020.6  00</usertag2></general><condition>PDFw9612,ValidDim,Shape,ValidWeight,ValidRead,LFT</condition><barcode cc="3" vcc="3"><codevalid id="n"><st>0</st><wud>0</wud><cs>37</cs><bdn>5</bdn><cl>20</cl><bc>S-BB065D1SLOF-WOC000</bc><condition>CLV,Camera,InfoBarcode,Info</condition><position unit="mm" x="940" y="1054" z="86" xmin="130" xmax="983"/><readlist>E8200000</readlist><norca fee="1" vee="1" rq="100" fv="0"><verifyvalues vvd="100" vgd="4" vvs="37" vgs="1" vvr="5" vgr="4" vve="13" vge="0" vvm="36" vgm="0" vvde="8" vgde="4" vgo="4"/></norca><devices><device dn="5"><dcs>9</dcs><position unit="mm" x="1240" y="1054" z="86"/><norca fee="1" vee="1" rq="100" fv="0"><verifyvalues vvd="100" vgd="4" vvs="37" vgs="1" vvr="5" vgr="4" vve="13" vge="0" vvm="36" vgm="0" vvde="8" vgde="8" vgo="4"/></norca></device><device dn="11"><dcs>3</dcs><position unit="mm" x="2111" y="840" z="64"/><norca fee="0" vee="0" rq="0" fv="0"/></device><device dn="3"><dcs>9</dcs><position unit="mm" x="2750" y="769" z="88"/><norca fee="1" vee="1" rq="100" fv="0"><verifyvalues vvd="100" vgd="4" vvs="45" vgs="2" vvr="5" vgr="4" vve="12" vge="0" vvm="28" vgm="0" vvde="7" vgde="7" vgo="0"/></norca></device><device dn="2"><dcs>8</dcs><position unit="mm" x="2795" y="1050" z="71"/><norca fee="1" vee="1" rq="89" fv="0"><verifyvalues vvd="89" vgd="0" vvs="28" vgs="1" vvr="4" vgr="4" vve="9" vge="0" vvm="32" vgm="0" vvde="5" vgde="5" vgo="0"/></norca></device><device dn="1"><dcs>8</dcs><position unit="mm" x="2928" y="811" z="69"/><norca fee="1" vee="1" rq="89" fv="0"><verifyvalues vvd="89" vgd="0" vvs="34" vgs="1" vvr="7" vgr="4" vve="14" vge="0" vvm="42" vgm="1" vvde="8" vgde="8" vgo="3"/></norca></device></devices></codevalid><codevalid id="n"><st>0</st><wud>0</wud><cs>25</cs><bdn>11</bdn><cl>22</cl><bc>9612850147114161000158</bc><condition>FXGtrack11,T1T2,T1,RefBarcode,FXG9612,CLV,Camera,Ref</condition><position unit="mm" x="736" y="869" z="85" xmin="653" xmax="736"/><readlist>80300000</readlist><norca fee="1" vee="1" rq="100" fv="0"><verifyvalues vvd="100" vgd="4" vvs="67" vgs="3" vvr="8" vgr="4" vve="41" vge="4" vvm="60" vgm="3" vvde="6" vgde="4" vgo="26"/></norca><devices><device dn="12"><dcs>7</dcs><position unit="mm" x="1704" y="817" z="87"/><norca fee="0" vee="0" rq="0" fv="0"/></device><device dn="11"><dcs>9</dcs><position unit="mm" x="2144" y="869" z="85"/><norca fee="0" vee="0" rq="0" fv="0"/></device><device dn="1"><dcs>9</dcs><position unit="mm" x="2928" y="842" z="70"/><norca fee="1" vee="1" rq="100" fv="0"><verifyvalues vvd="100" vgd="4" vvs="67" vgs="3" vvr="8" vgr="4" vve="41" vge="4" vvm="60" vgm="3" vvde="6" vgde="6" vgo="26"/></norca></device></devices></codevalid><codevalid id="r"><st>0</st><wud>0</wud><cs>0</cs><bdn>1</bdn><cl>269</cl><bc>[)&gt;[0x1E]01[0x1D]0210471[0x1D]840[0x1D]850[0x1D]147114161000158[0x1D]FDEB[0x1D]1471141[0x1D]040[0x1D][0x1D]6/6[0x1D]21.0LB[0x1D]N[0x1D]5900 ARLINGTON AVE[0x1D]BRONX[0x1D]NY[0x1D]STEVEN HERSH[0x1E]06[0x1D]10ZGH006[0x1D]11Z [0x1D]12Z3018385983[0x1D]14ZAPT 18A[0x1D]18Z251647020[0x1C]EX[0x1D]23ZN[0x1D]22Z[0x1C]N[0x1D]20Z0.00[0x1C]0[0x1D]28Z147114161000103[0x1D]31Z                                  [0x1D]9K76117628[0x1D]26Z8803[0x1C][0x1D][0x1E][0x4]</bc><condition>FXG2DBarcode,RefBarcode,PDF,Camera,Ref</condition><position unit="mm" x="592" y="856" z="70" xmin="592" xmax="592"/><readlist>80000000</readlist><norca fee="0" vee="0" rq="0" fv="0"/><devices><device dn="1"><due>0</due><position unit="mm" x="2928" y="856" z="70"/><norca fee="0" vee="0" rq="0" fv="0"/></device></devices></codevalid></barcode><volumetric oms1="0000" oms2="00000000" oms3="10000001"><size unit="inch" ole="39.80" owi="10.80" ohe="2.60"/><oa unit="degree/10"><value>-3</value></oa><obv unit="inch3/10"><value>11176</value></obv><orv unit="inch3/10"><value>11154</value></orv><otve unit="mm/sec"><value>2794</value></otve><polygon unit="inch" oc1x="0.00" oc1y="41.30" oc1z="2.68" oc2x="0.05" oc2y="30.48" oc2z="2.68" oc3x="39.38" oc3y="41.48" oc3z="2.68" oc4x="39.43" oc4y="30.66" oc4z="2.68"/></volumetric><sorterstate state="started"><speed unit="ft/min"><value>544.49</value></speed></sorterstate><sortstate session="SOS" sortname="%{time} Day"/><ocsdata><rxstring>02/10/2012;17:58:53;0206;00;4059;070;0015549346</rxstring><rxoffset>6.80</rxoffset><rxfields><ss>00</ss><sw>0206</sw></rxfields><condition>OcsRx,OcsValid,OcsGood</condition><txfields><ss>00</ss><sw>0206</sw></txfields></ocsdata><scaledata ows="0"><owe unit="lbs"><value>20.60</value></owe></scaledata><hostmessage>]C10259612850147114161000158,PDF,]C1023S-BB065D1SLOF-WOC000</hostmessage></objectdata>'  % {sys_name: test_system_name, time: Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L"), obj_id: oi}
      socket.write("\x02") # start of text separator - can be alternatively written as socket.write [0x02].pack("C")
      socket.write(objdata) # push object string to server
      socket.write("\x03") # end of text separator
      socket.flush()
      sleep(delay)
    end
  elsif string_type == heartbeatdata
    push_count.times do
      hbdata = '<heartbeatdata xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="Logging.xsd" version="1.0"><devicename>%{sys_name}</devicename><deviceid>32</deviceid><timestamp>%{time}</timestamp><general errornb="0" iostate="8400"/><sorterstate state="started"><speed unit="ft/min"><value>546.26</value></speed></sorterstate><sortstate session="SOS" sortname="%{time} "/><systemstate><warning dn="6" errorid="03000401" numberoccurance="6" extinfo="CAN1: Dev. 6"><firsttimeoccur>%{time}</firsttimeoccur><lasttimeoccur>%{time}</lasttimeoccur></warning></systemstate></heartbeatdata>'   % {sys_name: test_system_name, time: Time.now.strftime("%Y-%m-%dT%H:%M:%S.%L")}
      socket.write("\x02") # start of text separator
      socket.write(hbdata) # push heart beat string to server
      socket.write("\x03") # end of text separator
      socket.flush()
      sleep(delay)
    end
  else
    puts "Incorrect string type is passed to the method, only heartbeatdata & objectdata are allowed as string types for now."
    raise TestCaseFailed, 'Incorrect data type passed in the step.'
  end
  # end TCP connection with server over specified port
  socket.close
end