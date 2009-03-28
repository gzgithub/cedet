;;; cogre-periodic.el --- Periodic table of COGRE nodes
;;
;; Copyright (C) 2009 Eric M. Ludlam
;;
;; Author: Eric M. Ludlam <eric@siege-engine.com>
;; X-RCS: $Id: cogre-periodic.el,v 1.3 2009-03-28 11:50:44 zappo Exp $
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Periodic table of COGRE nodes.
;;
;; @TODO - Each time a new node or link is created, add it to the
;;         periodic table.

;;; Code:
(require 'cogre-utest)
(require 'cogre-uml)

;;;###autoload
(defun cogre-periodic ()
  "Create a periodic table of COGRE objects."
  (interactive)
  ;; Setup the graph.
  (switch-to-buffer (get-buffer-create "*Graph Periodic*"))
  (erase-buffer)
  (kill-all-local-variables)
  (cogre "Periodic")
  ;; Put out the base items.
  (let ((n1 (cogre-periodic-make-node-at 2 1 'cogre-node "cogre-node"))
	(n2 (cogre-periodic-make-node-at 40 1 'cogre-node "cogre-node (2)")))
    (cogre-periodic-link-at n1 n2 'cogre-link))
  ;; Put out some UML class diagram elements items.
  (let ((p1 (cogre-periodic-make-node-at 2 7 'cogre-package "cogre-package"))
	(c1 (cogre-periodic-make-node-at 25 7 'cogre-class "cogre-class"))
	(c2 (cogre-periodic-make-node-at
	     23 18 'cogre-class "cogre-class (2)"
	     :attributes
	     (list
	      (semantic-tag-new-variable "fAttr" "int")
	      (semantic-tag-new-variable "fNice" "int")
	      )
	     :methods
	     (list
	      (semantic-tag-new-function "getAttr" "int" nil)
	      (semantic-tag-new-function "setAttr" "void"
					 (list (semantic-tag-new-variable
						"attr" "int"))))
	     )))
    (cogre-periodic-link-at p1 c1 'cogre-aggregate)
    (cogre-periodic-link-at c2 c1 'cogre-inherit))
  ;; Instance Diagram
  (let ((i1 (cogre-periodic-make-node-at 45 7 'cogre-instance "cogre-instance"))
	(i2 (cogre-periodic-make-node-at 45 28 'cogre-instance "cogre-instance (2)"))
	)
    (cogre-periodic-link-at i1 i2 'cogre-arrow))
  
  (cogre-render-buffer cogre-graph)
  )

(defun cogre-periodic-make-node-at (x y type name &rest
				      fields)
  "Create a node at X,Y with TYPE and NAME.
Optional FIELDS are fields to pass into the constructor."
  (picture-goto-coordinate x y)
  (let ((node (apply 'cogre-new-node (point) type fields)))
    (cogre-set-element-name node name)
    node))

(defun cogre-periodic-link-at (node1 node2 type)
  "Create a link between NODE1 and NODE2.
Link is created with the specified TYPE."
  (make-instance type :start node1 :end node2)
  )


(provide 'cogre-periodic)
;;; cogre-periodic.el ends here
