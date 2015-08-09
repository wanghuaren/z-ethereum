using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using ProtocolTool.core;

namespace ProtocolTool
{
    public partial class mainForm : Form
    {
        private OpenFileDialog openFileDialog = new OpenFileDialog();
        private FolderBrowserDialog folderBrowserDialog = new FolderBrowserDialog(); 
        public mainForm()
        {
            InitializeComponent();
            
        }
        private void init(){
            //创建连接对象
          
            openFileDialog.InitialDirectory = "D:\\";
            openFileDialog.Filter = "mdb File(*.mdb)|*.mdb";
            openFileDialog.RestoreDirectory = true;
            openFileDialog.FilterIndex = 1;

            folderBrowserDialog.SelectedPath="C:\\Users\\wanghuaren\\Documents\\Cocos\\CocosProjects\\CocosWeb\\Resources";
        }
        
        private void btnChoose_Click(object sender, EventArgs e)
        {
            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                txtPath.Text = openFileDialog.FileName;
                DBCtrl.instance.dbPah = openFileDialog.FileName;
            }
        }

        private void btnTransCC_Click(object sender, EventArgs e)
        {
            DBCtrl.instance.saveTabData("");
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog.ShowDialog() == DialogResult.OK)
            {
                textPathRes.Text = folderBrowserDialog.SelectedPath;
            }
        }

        private void btnCrypt_Click(object sender, EventArgs e)
        {
            Encrypt.instance.rootPath = textPathRes.Text;
            Encrypt.instance.encryptRes(textPathRes.Text);
        }
    }
}
