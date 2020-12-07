//
//  KeyboardHeightObservable.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import UIKit
import RxSwift

func keyboardHeightObservable() -> Observable<CGFloat> {
    return Observable
            .from([
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                            .map { notification -> CGFloat in
                                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                            },
                    NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                            .map { _ -> CGFloat in
                                0
                            }
            ])
            .merge()
}
