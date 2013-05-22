(restas:define-module #:ily
    (:use #:closer-mop #:cl #:iter #:alexandria #:anaphora #:postmodern #:lib)
  (:shadowing-import-from :closer-mop
                          :defclass
                          :defmethod
                          :standard-class
                          :ensure-generic-function
                          :defgeneric
                          :standard-generic-function
                          :class-name)
  (:export :get-look :all-look :find-look :vote))

(in-package #:ily)

;(closure-template:compile-template :common-lisp-backend (ylg:path "mod/ily/tpl.htm"))


(define-automat look "Автомат look-а"
  ((timestamp   :timestamp)
   (target      :target)
   (goods       :goods)
   (votes       :votes)
   (preview     :pic)
   (pic         :pic)
   (comments    :comments))
  (:draft :public :archived)
  ((:draft   :public    :publish-look)
   (:public  :archived  :archive-look)))

(define-entity vote ()
  ((user-id  :user-id)
   (look-id  :look-id)
   (voting   :voting)))

(defun vote (look-id voting &optional (current-user usr:*current-user*))
  (let ((vote (make-vote :look-id look-id
                         :user-id (usr::find-user (usr::get-user current-user))
                         :voting voting))
        (look (get-look look-id)))
    (setf (votes look)
          (append (votes look)
                  (list (find-vote vote))))))

;; (vote 1 'like 3)
;; (votes (get-look 1))
;; (look-id (get-vote 1))
;; (user-id (get-vote 1))


;; (defun show-create ()
;;   "ook"
;;   t)

;; (defun show-edit ()
;;   "ook"
;;   t)

;; (defun show-look ()
;;   "просмотр look-а"
;;   t)

;; (defun show-look-preview ()
;;   "review — просмотр миниатюры look-а"
;;   t)

;; (defun action-publish ()
;;   "ook")

;; (defun action-delete ()
;;   "ook")

;; (defun action-vote ()
;;   "ook")





;; Tests

;; Owner создает look,
;; загружает в него фотографии
;; и опционально добавляет данные (перечисленные в разделе "Данные").
;; Look создается в состоянии draft
;; TODO: фотографию при загрузке можно редактировать фильтрами (js)
;; TODO: добавить крон на время голосования
(make-look :timestamp (get-universal-time)
           :target '("club")
           :goods  '("shoes" "hat")
           :votes  nil
           :preview "1x.jpg"
           :pic "1.jpg"
           :comments 'comments
           :state :draft)

(make-look :timestamp (get-universal-time)
           :target '("club2")
           :goods  '("shoes2" "hat2")
           :votes  nil
           :preview "2x.jpg"
           :pic "2.jpg"
           :comments 'comments
           :state :draft)

(make-look :timestamp (get-universal-time)
           :target '("club2")
           :goods  '("shoes2" "hat2")
           :votes  nil
           :preview "3x.jpg"
           :pic "3.jpg"
           :comments 'comments
           :state :draft)

(make-look :timestamp (get-universal-time)
           :target '("club2")
           :goods  '("shoes2" "hat2")
           :votes  nil
           :preview "4x.jpg"
           :pic "4.jpg"
           :comments 'comments
           :state :draft)

(assert (equal 'look (type-of (get-look 1))))

;; ;; (опционально) Owner редактирует look, добавляя, удаляя или изменяя данные и фотографии.

;; (define-action edit-look (flds)
;;   "редактирование look-а owner-ом"
;;   ;; Проверка прав (around methods)
;;   ;; Проверка корректности данных (наличие, попадание в диапазон)
;;   ;; Замена полей look-а
;;   )

;; Owner публикует look, переводя его в состояние published. С этого момента look можно комментировать и за него можно голосовать.
(defun publish-look ()
  "публикация look-a owner-ом"
  (print 'pub))

(takt (get-look 1) :public :publish-look)

(assert (equal :public (state (get-look 1))))


;; Голосование
;; TODO

;; Архивирование look-а
(defun archive-look ()
  (print 'arch))

(takt (get-look 1) :archived :archive-look)

(assert (equal :archived (state (get-look 1))))

;; ;; Удаление look-а
;; (del-look 1)

;; (assert (equal nil (ignore-errors (get-look 1))))

;; ;; Список всех look-ов

;; (all-look)

;; ;; Показ конкретного look-а

;; (get-look)

;; Голосование

;; Попытка голосовать за лук не в том состоянии

;; Комментирование look-а
