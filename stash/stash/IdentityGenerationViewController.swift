//
//  IdentityGenerationViewController.swift
//  stash
//
//  Created by James Stidard on 24/01/2015.
//  Copyright (c) 2015 James Stidard. All rights reserved.
//

import UIKit
import CoreData

let IdentityCreationSegueId = "IdentityCreationSegue"

class IdentityGenerationViewController: UIViewController, ContextDriven {
    
    var context: NSManagedObjectContext?
    var entropyMachine = EntropyMachine()
    lazy var harvesters: [EntropyHarvester]         = [self.gyroHarvester, self.accelHarvester]
    lazy var gyroHarvester: GyroHarvester           = GyroHarvester(machine: self.entropyMachine)
    lazy var accelHarvester: AccelerometerHarvester = AccelerometerHarvester(machine: self.entropyMachine)
    var identity: Identity?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startHarvesting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func startHarvesting() {
        self.activityIndicator.startAnimating()
        self.entropyMachine.start()
        self.harvesters.map({$0.start()}) // start harvesters gathering entropy for the machine
    }
    
    private func stopHarvesting() -> NSData? {
        self.activityIndicator.stopAnimating()
        self.harvesters.map({$0.stop()})
        return self.entropyMachine.stop()
    }
    
    @IBAction func continueButtonPressed(sender: UIButton) {
        // Stop the harvester and get the seed
        if let seed = self.stopHarvesting() {
            if let context = Stash.sharedInstance.context {
                identity = Identity.createIdentity(nameTextField.text, seed: seed, context: context)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        if identity != nil {
            context?.deleteObject(identity!)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destinationVC = segue.destinationViewController as? IdentityHolder {
            destinationVC.identity = identity
        }
    }
    

}