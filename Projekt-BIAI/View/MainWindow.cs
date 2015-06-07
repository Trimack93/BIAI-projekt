using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using Projekt_BIAI.Model;
using RDotNet;
using RDotNet.NativeLibrary;

namespace Projekt_BIAI
{
    public partial class MainWindow : Form
    {
        /// <summary>
        /// Nasza instancja silnika R - może przyjmować wyrażenia w języku R lub odpalać gotowe skrypty
        /// </summary>
        private _REngine RConnector;

        public MainWindow()
        {
            InitializeComponent();

            RConnector = new _REngine();

            RConnector.Initialize();

        }

        private void MainWindow_Load(object sender, EventArgs e)
        {
            comboBox1.SelectedIndex = 0;
            //panel1.Visible = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                if (comboBox1.SelectedIndex == 1)
                {
                    pictureBox1.Visible = true;
                    label7.Visible = true;

                    pictureBox1.Image = Projekt_BIAI.Properties.Resources.loading;
                    label7.ForeColor = Color.Blue;
                    label7.Text = "Trwa przetwarzanie...";

                    // TODO: odpalić osobny wątek
                    RConnector.launchScript("Forest2", true, treeNumber.Value.ToString(),
                                                                numericUpDown1.Value.ToString(),
                                                                numericUpDown2.Value.ToString(),
                                                                numericUpDown3.Value.ToString(),
                                                                numericUpDown4.Value.ToString(),
                                                                numericUpDown5.Value.ToString());
                    
                    pictureBox1.Image = Projekt_BIAI.Properties.Resources.OK;
                    label7.ForeColor = Color.Green;
                    label7.Text = "Przetwarzanie zakończone!";
                }
            }
            catch (EvaluationException)
            {
                pictureBox1.Image = Projekt_BIAI.Properties.Resources.error;
                label7.ForeColor = Color.Red;
                label7.Text = "Wystąpił błąd!";
                //this.Close();

            }
        }

        private void MainWindow_FormClosed(object sender, FormClosedEventArgs e)
        {
            RConnector.DisposeEngine();
        }

       
    }
}
