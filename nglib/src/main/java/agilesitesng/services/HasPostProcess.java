package agilesitesng.services;

import COM.FutureTense.Interfaces.ICS;

/**
 * Post processing interface - currently used to post process attributes adding
 * mode informations.
 * 
 * @author msciab
 * 
 */
public interface HasPostProcess {
	public String postProcess(ICS ics);
}
