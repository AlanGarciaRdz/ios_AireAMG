//
//  Chart.swift
//  AireAMG
//
//  Created by Alan Garcia on 9/25/16.
//  Copyright © 2016 ShadowForge. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import JBChart


class Chart: UIViewController, JBLineChartViewDataSource, JBLineChartViewDelegate{
    

    
    //User configuration
    let defaults = UserDefaults.standard
    
    
    
    
    var global_cont = String() //
    var global_base = String() //Imeca / Conc
    //End user configuration
    
    
    var conc_values = [String]()
    var cal_values = [String]()
    var graph_values = [Double]()
    
    var lat_arg: String = ""
    var lon_arg: String = ""
    
    @IBOutlet weak var pm10btn: UIButton!
    @IBAction func pm10action(_ sender: AnyObject) {
        pm10btn.setImage(#imageLiteral(resourceName: "pm10sel"), for: [])
        
        otresimage.setImage(#imageLiteral(resourceName: "o3_logo-1"), for: [])
        coimage.setImage(#imageLiteral(resourceName: "co_logo-1"), for: [])
        noimage.setImage(#imageLiteral(resourceName: "nox_logo-1"), for: [])
        soimage.setImage(#imageLiteral(resourceName: "So_logo-1"), for: [])
        
        
        self.global_cont = "PM10"
        getdata()
        
    
    }
    
    @IBOutlet weak var otresimage: UIButton!
    @IBAction func Otresaction(_ sender: AnyObject) {
        
        pm10btn.setImage(#imageLiteral(resourceName: "pm10_logo"), for: [])
        
        let btnImage = UIImage(named: "o3_sel")
        otresimage.setImage(btnImage,for:UIControlState.normal)
        coimage.setImage(#imageLiteral(resourceName: "co_logo-1"), for: [])
        noimage.setImage(#imageLiteral(resourceName: "nox_logo-1"), for: [])
        soimage.setImage(#imageLiteral(resourceName: "So_logo-1"), for: [])
        
        self.global_cont = "O3"
        getdata()
        
    }
    
    @IBOutlet weak var coimage: UIButton!
    @IBAction func COaction(_ sender: AnyObject) {
        
        pm10btn.setImage(#imageLiteral(resourceName: "pm10_logo"), for: [])
        otresimage.setImage(#imageLiteral(resourceName: "o3_logo-1"), for: [])
        
        let btnImage = UIImage(named: "co_sel")
        coimage.setImage(btnImage,for:UIControlState.normal)
        
        noimage.setImage(#imageLiteral(resourceName: "nox_logo-1"), for: [])
        soimage.setImage(#imageLiteral(resourceName: "So_logo-1"), for: [])
        
        
        
        self.global_cont = "CO"
        getdata()
        
        
        
    }
    
    
    @IBOutlet weak var noimage: UIButton!
    
    @IBAction func NOaction(_ sender: AnyObject) {
        
    }
    
    @IBAction func NOaction_(_ sender: AnyObject) {
        
        pm10btn.setImage(#imageLiteral(resourceName: "pm10_logo"), for: [])
        otresimage.setImage(#imageLiteral(resourceName: "o3_logo-1"), for: [])
        
        coimage.setImage(#imageLiteral(resourceName: "co_logo-1"), for: [])
        
        let btnImage = UIImage(named: "nox_sel")
        noimage.setImage(btnImage,for:UIControlState.normal)

        soimage.setImage(#imageLiteral(resourceName: "So_logo-1"), for: [])
        
        self.global_cont = "NOX"
        getdata()
        
    }
    
    
    @IBOutlet weak var soimage: UIButton!
    @IBAction func SOaction(_ sender: AnyObject) {
        
        
        pm10btn.setImage(#imageLiteral(resourceName: "pm10_logo"), for: [])
        otresimage.setImage(#imageLiteral(resourceName: "o3_logo-1"), for: [])
        
        coimage.setImage(#imageLiteral(resourceName: "co_logo-1"), for: [])
        noimage.setImage(#imageLiteral(resourceName: "nox_logo-1"), for: [])
        
        let btnImage = UIImage(named: "So_sel")
        soimage.setImage(btnImage,for:UIControlState.normal)
        
        
        self.global_cont = "SOX"
        getdata()
        
    }
    
    //Chart variables
    var chartData = [Double]()
    
    @IBOutlet weak var LineChart: JBLineChartView!
    
    
    override func viewDidLoad() {
        
        getUser_Conf()
        drawchart()
        
        
        
        
        
        
        if(defaults.value(forKey: "lat") == nil){
            lat_arg = "20.660291"
        }else{
            lat_arg =  (defaults.value(forKey: "lat") as! String?)!

        }
        if(defaults.value(forKey: "lon") == nil){
            lon_arg = "-103.396454"
        }else{
            lon_arg =  (defaults.value(forKey: "lon") as! String?)!
        }
        
        print("data is \(lat_arg)");
        print("data is \(lon_arg)");
        
        getdata()
        

        
        
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        getUser_Conf()
    }
    
    func getUser_Conf(){
        
        
        if defaults.bool(forKey: "PM10"){
            self.global_cont = "PM10"
        }else if defaults.bool(forKey: "SOX"){
            self.global_cont = "SOX"
        }else if defaults.bool(forKey: "CO"){
            self.global_cont = "CO"
        }else if defaults.bool(forKey: "O3"){
            self.global_cont = "O3"
        }else if defaults.bool(forKey: "NOX"){
            self.global_cont = "NOX"
        }else{
            self.global_cont = "PM10"
            pm10btn.setImage(#imageLiteral(resourceName: "pm10sel"), for: [])
            
        }
        
        //getdata()
        
        
        
        /*if defaults.bool(forKey: "concentracion"){
            self.global_base = "conc"
        }else if defaults.bool(forKey: "imeca"){
            self.global_base = "imeca"
        }else{
            self.global_base = "imeca"
        }*/
        
        if defaults.object(forKey: "graficar") != nil{
        
        
            let valuegraf = defaults.value(forKey: "graficar") as! String?
            if(valuegraf == "imeca"){
                self.global_base = "imeca"
                self.title = "IMECA"
            }
            if(valuegraf == "concentracion"){
                self.global_base = "conc";
                self.title = "Concentración (ug/m3)"
            }

        }
        
        
        
        
        print(self.global_cont)
        print(self.global_base)
        
        
    }
    
    func getdata(){
        
        let valuegraf = defaults.value(forKey: "graficar") as! String?
        if(valuegraf == "imeca"){
            self.global_base = "imeca"
            self.title = "IMECA"
        }
        if(valuegraf == "concentracion"){
            self.global_base = "conc";
            self.title = "Concentración (ug/m3)"
        }

        //print(lat_arg)
        //print(lon_arg)
        let parameters = ["lat": lat_arg,"lon": lon_arg ]
        //lat_arg = "20.660291"
        //lon_arg = "-103.396454"
        var baseURL = "http://149.56.132.38:3001/all?lat="+lat_arg+"&lon="+lon_arg
        baseURL = "http://149.56.132.38:3001/all"
        
        conc_values = [String]()
        cal_values = [String]()
        graph_values = [Double]()
        
        
       
        
        
        Alamofire.request( baseURL, parameters: parameters)
            .responseJSON { response in
                // handle JSON
                
                let data = response.data
                do {
                    let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: AnyObject]]
                    
                    if let contaminantes = json??[0]["All"] as? [[String: AnyObject]]{
                    
                    
                    
                        for contaminante in contaminantes {
                            if let vals = contaminante[self.global_cont] as? [[String: AnyObject]] {
                                for val in vals {
                                    //print(val[self.global_base])
                                    if let conc_val = val[self.global_base]  {
                                        self.conc_values.append(String(format:"%f", conc_val.doubleValue))
                                        self.graph_values.append(conc_val.doubleValue)
                                    }
                                
                                    if let cal_val = val["calidad"]{
                                        self.cal_values.append(cal_val as! String)
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    print("error serializing JSON: \(error)")
                }
                
                print(self.global_cont)
                print(self.conc_values)
                print(self.cal_values)
                
                
                //Chart
                self.chartData =   self.graph_values
                let max =  self.graph_values.max()
                let min =  self.graph_values.min()
                print(max)
                print(min)
                print(String(format:"%.1f", max!));
                self.lblmaxchart.text = String(format:"%.1f", max!);
                self.lblmidchart.text = "";//String(format:"%.1f",max! - min!);
                self.lbllowchart.text = String(format:"%.1f", min!);
                
                
                self.LineChart.minimumValue = CGFloat(min!)
                self.LineChart.maximumValue = CGFloat(max!)
                
                
                
                self.LineChart.reloadData(animated: true)

                
            }
        
    }
    
    @IBOutlet weak var lblmaxchart: UILabel!
    
    @IBOutlet weak var lblmidchart: UILabel!
    
    @IBOutlet weak var lbllowchart: UILabel!
    
    func drawchart(){
        
        // line chart setup
        LineChart.backgroundColor = UIColor.white
        LineChart.delegate = self
        LineChart.dataSource = self
        
        
        
        chartData =   [70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70, 70]
        LineChart.reloadData()
        //LineChart.reloadDataAnimated(true`)
        
        LineChart.setState(.collapsed, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //let footerView = UIView(frame: CGRectMake(0, 0, LineChart.frame.width, 10))
        
        print("viewDidLoad: \(LineChart.frame.width)")
        
        /*let footer1 = UILabel(frame: CGRectMake(0, 0, LineChart.frame.width/2 - 8, 10))
        footer1.font = UIFont.systemFont(ofSize: 5)
        footer1.textColor = UIColor.red
        footer1.text = "\(chartLegend[0])"
        
        let footer2 = UILabel(frame: CGRectMake(LineChart.frame.width/2 - 8, 0, LineChart.frame.width/2 - 8, 12))
        footer2.textColor = UIColor.red
        footer2.font = UIFont.systemFont(ofSize: 5)
        footer2.text = "\(chartLegend[chartLegend.count - 1])"
        footer2.textAlignment = NSTextAlignment.right
        
        
        
        footerView.addSubview(footer1)
        footerView.addSubview(footer2)*/
        
        /*let header = UILabel(frame: CGRectMake(0, 0, LineChart.frame.width, 10))
         header.textColor = UIColor.blackColor()
         header.font = UIFont.systemFontOfSize(12)
         header.text = "Grafica del contaminante: " + self.global_cont
         header.textAlignment = NSTextAlignment.Center*/
        
        //LineChart.footerView = footerView
        //LineChart.headerView = header
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        LineChart.reloadData()
        
        var timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(Chart.showChart), userInfo: nil, repeats: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideChart()
    }
    
    func hideChart() {
        LineChart.setState(.collapsed, animated: true)
    }
    
    func showChart() {
        LineChart.setState(.expanded, animated: true)
    }
    
    
    // MARK: JBlineChartView
    
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    public func numberOfLines(in lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if (lineIndex == 0) {
            return UInt(chartData.count)
        } else if (lineIndex == 1) {
            //return UInt(lastYearChartData.count)
        }
        
        return 15
    }
    
    
    
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        if (lineIndex == 0) {
            return CGFloat(chartData[Int(horizontalIndex)])
        } else if (lineIndex == 1) {
            //return CGFloat(lastYearChartData[Int(horizontalIndex)])
        }
        
        return 15
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        
        
        return UIColor(red:0.12, green:0.85, blue:0.85, alpha:1.0)   //#1ed9d9
    }
    
    
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 1
    }
    
    
    
    
    // MARK: dot linechart
    
    func lineChartView(_ lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 3
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        if (lineIndex == 0) { return true }
        else if (lineIndex == 1) { return false }
        
        return false
    }
    
    
    func lineChartView(_ lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor(red:0.00, green:1.00, blue:1.00, alpha:1.0)   //00ffff
    }
    
    func lineChartView(_ lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        if (lineIndex == 0) { return false }
        else if (lineIndex == 1) { return true }
        
        return true
    }
    
    
    
    //MARK: Info Label
    
    
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var imgestado: UIImageView!
    
    @IBOutlet weak var lblCalidad: UILabel!
    var chartLegend = ["C", "1","2","3","4","5","6","7","8", "9","10","11","12","13","14","15","16","17","18", "19", "20", "21", "22", "23", "24"]
    
    func lineChartView(_ lineChartView: JBLineChartView!, didSelectLineAt lineIndex: UInt, horizontalIndex: UInt) {
        if (lineIndex == 0) {
            let data = chartData[Int(horizontalIndex)]
            let key = chartLegend[Int(horizontalIndex)]
            informationLabel.text = "Hora: \(key): valor: \(data)"
            
            lblCalidad.text = self.cal_values[Int(horizontalIndex)]
            
            if(lblCalidad.text == "Buena"){
                imgestado.image = UIImage(named: ("Calidad_buena-1"))
            }else if(lblCalidad.text == "Regular"){
                imgestado.image = UIImage(named: ("Calidad_int-1"))
            }else if(lblCalidad.text == "Mala"){
                imgestado.image = UIImage(named: ("Calidad_mala-1"))
            }else if(lblCalidad.text == "Extremadamente Mala"){
                imgestado.image = UIImage(named: ("Calidad_Emala-1"))
            }
            
        } else if (lineIndex == 1) {
           
        }
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        //informationLabel.text = ""
    }
    
    func lineChartView(lineChartView: JBLineChartView!, fillColorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        if (lineIndex == 1) {
            return UIColor.white
        }
        
        return UIColor.clear
    }

}
