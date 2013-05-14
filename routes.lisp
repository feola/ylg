(in-package #:ylg)

;; 404

;; (defun page-404 (&optional (title "404 Not Found") (content "Страница не найдена"))
;;   (let* ((title "404 Not Found")
;;          (menu-memo (menu)))
;;     (restas:render-object
;;      (make-instance 'ylg-render)
;;      (list title
;;            menu-memo
;;            (tpl:default
;;                (list :title title
;;                      :navpoints menu-memo
;;                      :content "Страница не найдена"))))))

;; (restas:define-route not-found-route ("*any")
;;   (restas:abort-route-handler
;;    (page-404)
;;    :return-code hunchentoot:+http-not-found+
;;    :content-type "text/html"))


;; main

(restas:define-route main ("/")
  (tpl:root (list :left (tpl:left)
                  :right (tpl:right)
                  :enterform (tpl:enterform)
                  :auth (if (null usr:*current-user*)
                            (tpl:authnotlogged)
                            (tpl:authlogged (list :username (usr:email usr:*current-user*)))))))

(restas:define-route action-register ("/action-register" :method :post)
  (let ((data (alist-hash-table (hunchentoot:post-parameters*) :test #'equal)))
    (let ((user (usr:registration (gethash "login" data))))
      (if (null user)
          "account exists"
          (progn
            (usr:enter (usr:email user) (usr:password user))
            (json:encode-json-to-string (list (cons "location" "/"))))))))


(restas:define-route action-login ("/action-login" :method :post)
  (let ((data (alist-hash-table (hunchentoot:post-parameters*) :test #'equal)))
    (let ((login    (gethash "login" data))
          (password (gethash "password" data)))
      (if (usr:enter login password)
          ;; "ok"
          (json:encode-json-to-string (list
                                       (cons "passed" "true")
                                       (cons "location" "/")
                                       (cons "msg" "Добро пожаловать")))
          "Account not found"))))


(restas:define-route action-send-login ("/action-send-login" :method :post)
  (let ((data (alist-hash-table (hunchentoot:post-parameters*) :test #'equal)))
    (let ((login    (gethash "login" data)))
      (usr:send-login login))))


(restas:define-route action-logoff ("/action-logoff" :method :post)
  (usr:logoff)
  (json:encode-json-to-string (list (cons "location" "/"))))


(restas:define-route file ("/file" :method :post)
  (awhen (hunchentoot:post-parameter "file")
    (destructuring-bind (pathname filename format)
        it
      (alexandria:read-file-into-string pathname))))

;; plan file pages

(defmacro def/route (name param &body body)
  `(progn
     (restas:define-route ,name ,param
       ,@body)
     (restas:define-route
         ,(intern (concatenate 'string (symbol-name name) "/"))
         ,(cons (concatenate 'string (car param) "/") (cdr param))
       ,@body)))


;; (def/route about ("about")
;;   (path "content/about.org"))

(restas:mount-module -css- (#:restas.directory-publisher)
  (:url "/css/")
  (restas.directory-publisher:*directory* (path "css/")))

(restas:mount-module -js- (#:restas.directory-publisher)
  (:url "/js/")
  (restas.directory-publisher:*directory* (path "js/")))

(restas:mount-module -img- (#:restas.directory-publisher)
  (:url "/img/")
  (restas.directory-publisher:*directory* (path "img/")))
