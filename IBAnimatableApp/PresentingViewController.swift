//
//  Created by Tom Baranes on 16/07/16.
//  Copyright © 2016 Jake Lin. All rights reserved.
//

import UIKit
import IBAnimatable

class PresentingViewController: AnimatableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

  // MARK: Properties IB

  @IBOutlet weak var btnAnimationType: AnimatableButton!
  @IBOutlet weak var btnDismissalAnimationType: AnimatableButton!
  @IBOutlet weak var btnModalPosition: AnimatableButton!
  @IBOutlet weak var btnModalSize: AnimatableButton!
  @IBOutlet weak var btnKeyboardTranslation: AnimatableButton!
  @IBOutlet weak var btnBlurEffectStyle: AnimatableButton!
  @IBOutlet weak var btnBackgroundColor: AnimatableButton!
  @IBOutlet weak var btnShadowColor: AnimatableButton!

  @IBOutlet weak var labelCornerRadius: UILabel!
  @IBOutlet weak var labelOpacity: UILabel!
  @IBOutlet weak var labelBlurOpacity: UILabel!
  @IBOutlet weak var labelShadowOpacity: UILabel!
  @IBOutlet weak var labelShadowRadius: UILabel!
  @IBOutlet weak var labelShadowOffsetX: UILabel!
  @IBOutlet weak var labelShadowOffsetY: UILabel!

  @IBOutlet weak var dimmingPickerView: AnimatableView!
  @IBOutlet weak var containerPickerView: AnimatableView!
  @IBOutlet weak var pickerView: UIPickerView!

  @IBOutlet var sliderCornerRadius: UISlider!
  @IBOutlet var switchDismissOnTap: UISwitch!
  @IBOutlet var sliderOpacity: UISlider!
  @IBOutlet var sliderBlurOpacity: UISlider!
  @IBOutlet var sliderShadowOpacity: UISlider!
  @IBOutlet var sliderShadowRadius: UISlider!
  @IBOutlet var sliderShadowOffsetX: UISlider!
  @IBOutlet var sliderShadowOffsetY: UISlider!

  // MARK: Properties

  private let animations = ["Flip", "CrossDissolve", "Cover(Left)", "Cover(Right)", "Cover(Top)", "Cover(Bottom)", "Zoom", "DropDown"]
  private let positions = ["Center", "TopCenter", "BottomCenter", "LeftCenter", "RightCenter", "CustomCenter", "CustomOrigin"]
  private let sizes = ["Half", "Full", "Custom"]
  private let keyboardTranslations = ["MoveUp", "AboveKeyboard"]
  private let blurEffectStyles = ["ExtraLight", "Light", "Dark"]

  private var selectedButton: UIButton?

  private var selectedAnimationType: String?
  private var selectedDismissalAnimationType: String?
  private var selectedModalPosition: String?
  private var selectedModalWidth: String?
  private var selectedModalHeight: String?
  private var selectedKeyboardTranslation: String?
  private var selectedBlurEffectStyle: String?
  private var selectedBackgroundColor: UIColor?
  private var selectedShadowColor: UIColor?

  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  private func setupModal(presentedViewController: AnimatableModalViewController) {
    presentedViewController.presentationAnimationType = selectedAnimationType
    presentedViewController.dismissalAnimationType = selectedDismissalAnimationType
    presentedViewController.modalPosition = selectedModalPosition ?? "Center"
    presentedViewController.modalWidth = selectedModalWidth ?? "Half"
    presentedViewController.modalHeight = selectedModalHeight ?? "Half"
    presentedViewController.backgroundColor = selectedBackgroundColor ?? .blackColor()
    presentedViewController.dismissOnTap = switchDismissOnTap.on
    presentedViewController.keyboardTranslation = selectedKeyboardTranslation
    presentedViewController.cornerRadius = CGFloat(sliderCornerRadius.value)
    presentedViewController.blurOpacity = CGFloat(sliderBlurOpacity.value)
    presentedViewController.shadowColor = selectedShadowColor
    presentedViewController.shadowOpacity = CGFloat(sliderShadowOpacity.value)
    presentedViewController.shadowRadius = CGFloat(sliderShadowRadius.value)
    presentedViewController.shadowOffset = CGPoint(x: CGFloat(sliderShadowOffsetX.value), y: CGFloat(sliderShadowOffsetY.value))

    setDismissalAnimationTypeIfNeeded(presentedViewController)
  }

  private func setDismissalAnimationTypeIfNeeded(viewController: AnimatableModalViewController) {
    // FIXME: Dirty hack to make `Flip` and `CrossDissolve` work properly for dismissal transition.
    // If we don't apply this hack, both the dismissal transitions of `Flip` and `CrossDissolve` will slide down the modal not flip or crossDissolve(fade).
    if viewController.presentationAnimationType == "Flip" {
      viewController.dismissalAnimationType = "Flip"
    } else if viewController.presentationAnimationType == "CrossDissolve" {
      viewController.dismissalAnimationType = "CrossDissolve"
    }
  }
}

// MARK: - IBAction

extension PresentingViewController {

  @IBAction func presentProgramatically() {
    if let presentedViewController = UIStoryboard(name: "Presentations", bundle: nil).instantiateViewControllerWithIdentifier("PresentationPresentedViewController") as? AnimatableModalViewController {
      setupModal(presentedViewController)
      presentViewController(presentedViewController, animated: true, completion: nil)
    }
  }

  @IBAction func animationTypePressed() {
    selectedButton = btnAnimationType
    showPicker()
  }

  @IBAction func dismissalAnimationTypePressed() {
    selectedButton = btnDismissalAnimationType
    showPicker()
  }

  @IBAction func modalPositionPressed() {
    selectedButton = btnModalPosition
    showPicker()
  }

  @IBAction func modalSizePressed() {
    selectedButton = btnModalSize
    showPicker()
  }

  @IBAction func keyboardTranslationPressed() {
    selectedButton = btnKeyboardTranslation
    showPicker()
  }

  @IBAction func backgroundColorPressed() {
    selectedButton = btnBackgroundColor
  }

  @IBAction func shadowColorPressed() {
    selectedButton = btnShadowColor
  }

  @IBAction func blurEffectStylePressed() {
    selectedButton = btnBlurEffectStyle
    showPicker()
  }

}

// MARK: - Slider value changed

extension PresentingViewController {

  @IBAction func cornerRadiusValueChanged(sender: UISlider) {
    labelCornerRadius.text = "Corner radius (\(sender.value))"
  }

  @IBAction func opacityValueChanged(sender: UISlider) {
    labelOpacity.text = "Opacity (\(sender.value))"
  }

  @IBAction func blurOpacityValueChanged(sender: UISlider) {
    labelBlurOpacity.text = "Blur opacity (\(sender.value))"
  }

  @IBAction func shadowOpacityValueChanged(sender: UISlider) {
    labelShadowOpacity.text = "Shadow opacity (\(sender.value))"
  }

  @IBAction func shadowRadiusValueChanged(sender: UISlider) {
    labelShadowRadius.text = "Shadow radius (\(sender.value))"
  }

  @IBAction func shadowOffsetXValueChanged(sender: UISlider) {
    labelShadowOffsetX.text = "Shadow offset X (\(sender.value))"
  }

  @IBAction func shadowOffsetYValueChanged(sender: UISlider) {
    labelShadowOffsetY.text = "Shadow offset Y (\(sender.value))"
  }
}

// MARK: - Picker

extension PresentingViewController {

  func showPicker() {
    pickerView.reloadAllComponents()
    dimmingPickerView.fadeIn()
    containerPickerView.slideInUp()
    dimmingPickerView.hidden = false
  }

  @IBAction func hidePicker() {
    dimmingPickerView.fadeOut({
      self.dimmingPickerView.hidden = true
    })
    containerPickerView.slideOutDown()
  }

  // MARK: Helpers

  func componentsForSelectedButton() -> [[String]] {
    if selectedButton == btnAnimationType || selectedButton == btnDismissalAnimationType {
      return [animations]
    } else if selectedButton == btnModalPosition {
      return [positions]
    } else if selectedButton == btnModalSize {
      return [sizes]
    } else if selectedButton == btnKeyboardTranslation {
      return [keyboardTranslations]
    }
    return [blurEffectStyles]
  }

  // MARK: UIPickerDelegate / DataSource

  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return componentsForSelectedButton().count
  }

  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return componentsForSelectedButton()[component].count
  }

  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return componentsForSelectedButton()[component][row]
  }

  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let title = componentsForSelectedButton()[0][row]
    if selectedButton == btnAnimationType {
      btnAnimationType.setTitle("Animation type (\(title))", forState: .Normal)
      selectedAnimationType = title
    } else if selectedButton == btnDismissalAnimationType {
      btnDismissalAnimationType.setTitle("Dismissal animation type (\(title))", forState: .Normal)
      selectedDismissalAnimationType = title
    } else if selectedButton == btnModalPosition {
      btnModalPosition.setTitle("Modal Position (\(title))", forState: .Normal)
      selectedModalPosition = title
    } else if selectedButton == btnModalSize {
      btnModalSize.setTitle("Modal size (\(title))", forState: .Normal)
      selectedModalWidth = title
    } else if selectedButton == btnKeyboardTranslation {
      btnKeyboardTranslation.setTitle("Keyboard translation (\(title))", forState: .Normal)
      selectedKeyboardTranslation = title
    } else if selectedButton == btnBlurEffectStyle {
      btnBlurEffectStyle.setTitle("Blur effect style (\(title))", forState: .Normal)
      selectedBlurEffectStyle = title
    }
  }
  
}
