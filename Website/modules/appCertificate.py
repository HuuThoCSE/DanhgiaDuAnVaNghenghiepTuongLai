from flask import Blueprint, request, render_template, session, url_for, redirect
import mysql.connector

# Tạo Blueprint cho module
appCertificate = Blueprint('appCertificate', __name__, static_folder='../statics')